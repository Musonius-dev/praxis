# CSS Quality — Generation Constraints
# Scope: **/*.css, **/*.scss, **/*.less
# Active during code generation, not post-hoc review

## Invariants — BLOCK on violation

- No `!important` — fix the specificity problem instead.
- No hardcoded color values — use design tokens or CSS custom properties.
- No `px` for font sizes — use `rem` for scalability and accessibility.
- No `z-index` without a comment and reference to the project's z-index scale.
- No layout via `float` — use flexbox or grid.

## Conventions — WARN on violation

- CSS custom properties (`--var`) for all recurring values: spacing, colors, radii, shadows.
- Mobile-first media queries (`min-width`) — never desktop-first (`max-width`).
- Logical properties (`margin-inline`, `padding-block`) over physical (`margin-left`, `padding-top`).
- `gap` for spacing between flex/grid items — not margin hacks on children.
- Prefer `clamp()` for fluid typography and spacing over media query breakpoints.
- `:focus-visible` over `:focus` for keyboard-only focus indicators.
- `prefers-reduced-motion` media query wrapping any animation or transition.
- BEM or utility-class convention — never bare tag selectors outside resets.

## Removal Condition
Remove when a CSS-specific linter rule engine replaces generation-time constraints.
