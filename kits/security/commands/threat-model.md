---
description: "STRIDE-based threat modeling for the current system"
---

# security:threat-model

## Steps

1. **Identify system scope** — ask user for the component or feature to model
2. **Map data flows** — identify trust boundaries, data stores, external entities, processes
3. **Apply STRIDE** for each component crossing a trust boundary:
   - **S**poofing — can identity be faked?
   - **T**ampering — can data be modified in transit/at rest?
   - **R**epudiation — can actions be denied without audit trail?
   - **I**nformation Disclosure — can data leak to unauthorized parties?
   - **D**enial of Service — can the component be overwhelmed?
   - **E**levation of Privilege — can a user gain unauthorized access?
4. **Rate each threat**: likelihood (1-3) × impact (1-3) = risk score
5. **Recommend mitigations** for high-risk threats
6. **Write threat model** to vault `specs/threat-model-{date}-{component}.md`
