#!/usr/bin/env node
'use strict';

const fs = require('fs');
const path = require('path');
const yaml = require('js-yaml');

const {
  TARGETS,
  PROMPTS_DIR,
  loadPraxisConfig,
  loadProfile,
  mergeProfiles,
  loadBlocks,
  applyOverrides,
} = require('../lib/loader');

const {
  interpolate,
  findUnresolved,
  assembleClaudeCode,
  assembleClaudeProject,
  assemblePerplexitySpace,
} = require('../lib/assemblers');

const PROJECTS_DIR = path.join(PROMPTS_DIR, 'projects');

const CHAR_BUDGETS = {
  'claude-code': Infinity,
  'claude-project': 2500,
  'perplexity-space': 4000,
};

// Global flags set by CLI parser
let PREVIEW_MODE = false;
let DIFF_MODE = false;
let STRICT_MODE = false;

// ── Helpers ──────────────────────────────────────────────────

function fail(msg) {
  console.error(`\x1b[31mERROR:\x1b[0m ${msg}`);
  process.exit(1);
}

function warn(msg) {
  console.error(`\x1b[33mWARN:\x1b[0m ${msg}`);
}

function ok(msg) {
  console.log(`\x1b[32m✓\x1b[0m ${msg}`);
}

// ── Main ─────────────────────────────────────────────────────

/** Validate a standalone project — check files exist, report char budgets. */
function validateStandalone(projectName, projectDir, projectConfig) {
  console.log(`\nValidating standalone: ${projectName}`);

  const inventory = [
    { file: 'system-prompt.md', budget: Infinity, required: true, label: 'System Prompt (Claude Projects)' },
    { file: 'CLAUDE.md', budget: Infinity, required: false, label: 'Claude Code' },
    { file: 'space-instructions.md', budget: CHAR_BUDGETS['perplexity-space'], required: false, label: 'Perplexity Space' },
    { file: 'project-instructions.md', budget: CHAR_BUDGETS['claude-project'], required: false, label: 'Claude Project' },
  ];

  let missingGenerable = [];

  for (const item of inventory) {
    const filePath = path.join(projectDir, item.file);
    if (fs.existsSync(filePath)) {
      const content = fs.readFileSync(filePath, 'utf8');
      const charCount = content.length;
      const lineCount = content.split('\n').length;
      const sizeInfo = item.budget < Infinity
        ? `${charCount} chars (budget: ${item.budget})`
        : `${charCount} chars, ${lineCount} lines`;

      if (charCount > item.budget) {
        warn(`${item.file} exceeds budget: ${charCount} chars (limit: ${item.budget})`);
      } else {
        ok(`${item.file} — ${sizeInfo}`);
      }
    } else if (item.required) {
      warn(`${item.file} MISSING — standalone projects require a system prompt`);
    } else {
      missingGenerable.push(item.file);
    }
  }

  if (missingGenerable.length > 0) {
    console.log(`\n  Missing platform outputs: ${missingGenerable.join(', ')}`);
    console.log('  Run /px-prompt ' + projectName + ' to auto-generate from system-prompt.md');
  }

  // Version consistency check
  const systemPromptPath = path.join(projectDir, 'system-prompt.md');
  if (fs.existsSync(systemPromptPath) && projectConfig.version) {
    const spContent = fs.readFileSync(systemPromptPath, 'utf8');
    const versionMatch = spContent.match(/^version:\s*["']?([^"'\n]+)/m);
    if (versionMatch && versionMatch[1].trim() !== String(projectConfig.version).trim()) {
      warn(`Version mismatch: prompt-config.yaml says "${projectConfig.version}" but system-prompt.md says "${versionMatch[1].trim()}"`);
    }
  }

  // Check for reference files
  const refsDir = path.join(projectDir, 'references');
  if (fs.existsSync(refsDir)) {
    const refs = fs.readdirSync(refsDir).filter((f) => f.endsWith('.md'));
    if (refs.length > 0) {
      ok(`${refs.length} reference file(s): ${refs.join(', ')}`);
    }
  }
}

function compileProject(projectName, targets) {
  const projectDir = path.join(PROJECTS_DIR, projectName);
  const configPath = path.join(projectDir, 'prompt-config.yaml');

  if (!fs.existsSync(configPath)) {
    fail(`Project config not found: ${configPath}\nRun /px-prompt <project-name> to create one.`);
  }

  const projectConfig = yaml.load(fs.readFileSync(configPath, 'utf8'));

  // Standalone mode: validate files, report budgets, skip compilation
  if (projectConfig.mode === 'standalone') {
    validateStandalone(projectName, projectDir, projectConfig);
    return;
  }

  const praxisConfig = loadPraxisConfig();

  // Build vars map: project vars + praxis config + project name
  const vars = {
    ...praxisConfig,
    ...(projectConfig.vars || {}),
    project: projectConfig.project || projectName,
  };

  // Load profile: from named profile, project-local blocks, or _base fallback
  let profile;
  if (projectConfig.profile) {
    profile = loadProfile(projectConfig.profile, fail);
  } else if (projectConfig.blocks) {
    const base = loadProfile('_base', fail);
    profile = mergeProfiles(base, { blocks: projectConfig.blocks });
  } else {
    profile = loadProfile('_base', fail);
  }
  profile = applyOverrides(profile, projectConfig.overrides);

  const profileName = projectConfig.profile || 'project-local';
  console.log(`\nCompiling: ${projectName} (profile: ${profileName})`);

  const assemblers = {
    'claude-code': assembleClaudeCode,
    'claude-project': assembleClaudeProject,
    'perplexity-space': assemblePerplexitySpace,
  };

  const outputNames = {
    'claude-code': 'CLAUDE.md',
    'claude-project': 'project-instructions.md',
    'perplexity-space': 'space-instructions.md',
  };

  for (const target of targets) {
    const blocks = loadBlocks(profile, target, warn);
    let output = assemblers[target](blocks, projectConfig, vars);

    // Interpolate variables
    output = interpolate(output, vars);

    // Validate no unresolved placeholders
    const unresolved = findUnresolved(output);
    if (unresolved.length > 0) {
      if (STRICT_MODE) {
        fail(`[strict] Unresolved placeholders in ${target}: ${unresolved.join(', ')}`);
      }
      warn(`Unresolved placeholders in ${target}: ${unresolved.join(', ')}`);
    }

    // Check character budget
    const budget = CHAR_BUDGETS[target];
    if (output.length > budget) {
      if (STRICT_MODE) {
        fail(`[strict] ${target} exceeds budget: ${output.length} chars (limit: ${budget})`);
      }
      warn(`${target} output exceeds budget: ${output.length} chars (limit: ${budget})`);
    }

    const outputPath = path.join(projectDir, outputNames[target]);

    // Preview mode: print to stdout instead of writing
    if (PREVIEW_MODE) {
      console.log(`\n--- ${outputNames[target]} (${output.length} chars) ---`);
      console.log(output);
      continue;
    }

    // Diff mode: show diff against existing file before writing
    if (DIFF_MODE && fs.existsSync(outputPath)) {
      const existing = fs.readFileSync(outputPath, 'utf8');
      if (existing === output) {
        ok(`${outputNames[target]} — unchanged (${output.length} chars)`);
        continue;
      }
      console.log(`\n--- ${outputNames[target]} changed ---`);
      const existingLines = existing.split('\n');
      const outputLines = output.split('\n');
      const addedCount = outputLines.filter((l) => !existingLines.includes(l)).length;
      const removedCount = existingLines.filter((l) => !outputLines.includes(l)).length;
      console.log(`  +${addedCount} lines added, -${removedCount} lines removed`);
    }

    fs.writeFileSync(outputPath, output, 'utf8');
    ok(`${outputNames[target]} — ${output.length} chars → ${outputPath}`);
  }
}

// ── CLI ──────────────────────────────────────────────────────

function main() {
  const args = process.argv.slice(2);

  if (args.length === 0 || args.includes('--help')) {
    console.log('Usage: prompt-compile <project-name|--all> [options]');
    console.log('Options:');
    console.log('  --target <target>  claude-code|claude-project|perplexity-space|all');
    console.log('  --preview          Print output to stdout without writing files');
    console.log('  --diff             Show what changed before writing');
    console.log('  --strict           Exit with error on budget overruns or unresolved vars');
    console.log('  --list             List all projects with mode and file status');
    process.exit(0);
  }

  // --list mode: show all projects
  if (args.includes('--list')) {
    const projectDirs = fs.readdirSync(PROJECTS_DIR)
      .filter((d) => d !== '_template' && fs.statSync(path.join(PROJECTS_DIR, d)).isDirectory());
    if (projectDirs.length === 0) {
      console.log('No projects found.');
      process.exit(0);
    }
    console.log(`${'Project'.padEnd(20)} ${'Mode'.padEnd(12)} ${'System Prompt'.padEnd(15)} ${'Claude Proj'.padEnd(15)} ${'Perplexity'.padEnd(15)} ${'CLAUDE.md'.padEnd(12)} Refs`);
    console.log('-'.repeat(95));
    for (const name of projectDirs) {
      const dir = path.join(PROJECTS_DIR, name);
      const cfgPath = path.join(dir, 'prompt-config.yaml');
      const cfg = fs.existsSync(cfgPath) ? yaml.load(fs.readFileSync(cfgPath, 'utf8')) : {};
      const mode = cfg.mode || 'compiled';
      const fileStatus = (f) => {
        const p = path.join(dir, f);
        if (!fs.existsSync(p)) return '—';
        return `${fs.readFileSync(p, 'utf8').length} chars`;
      };
      const refsDir = path.join(dir, 'references');
      const refCount = fs.existsSync(refsDir)
        ? fs.readdirSync(refsDir).filter((f) => f.endsWith('.md')).length
        : 0;
      console.log(
        `${name.padEnd(20)} ${mode.padEnd(12)} ${fileStatus('system-prompt.md').padEnd(15)} ${fileStatus('project-instructions.md').padEnd(15)} ${fileStatus('space-instructions.md').padEnd(15)} ${fileStatus('CLAUDE.md').padEnd(12)} ${refCount}`
      );
    }
    process.exit(0);
  }

  // Parse global flags
  PREVIEW_MODE = args.includes('--preview');
  DIFF_MODE = args.includes('--diff');
  STRICT_MODE = args.includes('--strict');

  // Parse --target flag
  const targetIdx = args.indexOf('--target');
  let targets = TARGETS;
  if (targetIdx !== -1 && args[targetIdx + 1]) {
    const targetArg = args[targetIdx + 1];
    if (TARGETS.includes(targetArg)) {
      targets = [targetArg];
    } else if (targetArg !== 'all') {
      fail(`Unknown target: ${targetArg}. Use: ${TARGETS.join(', ')}, all`);
    }
  }

  // Determine project(s) to compile
  const flagValues = new Set();
  if (targetIdx !== -1 && args[targetIdx + 1]) {
    flagValues.add(args[targetIdx + 1]);
  }
  const projectArg = args.find((a) => !a.startsWith('--') && !flagValues.has(a));

  if (args.includes('--all')) {
    const projectDirs = fs.readdirSync(PROJECTS_DIR)
      .filter((d) => d !== '_template' && fs.statSync(path.join(PROJECTS_DIR, d)).isDirectory());

    if (projectDirs.length === 0) {
      fail('No projects found in prompts/projects/');
    }

    for (const projectName of projectDirs) {
      compileProject(projectName, targets);
    }
  } else if (projectArg) {
    compileProject(projectArg, targets);
  } else {
    fail('Specify a project name or use --all');
  }

  console.log('\nDone.');
}

main();
