---
id: tlf-ybi2
status: open
deps: []
links: []
created: 2026-04-24T22:00:33Z
type: feature
priority: 3
assignee: Steve Trefethen
tags: [epic:tk-tooling]
---
# Show tier / plan / parent / children / epic block in tk show

Migrated 2026-04-24 from fullstack-starter/fs-axo5 (wrong repo home — this is tk-core work, not fullstack-starter work).

Codex feedback (2026-04-24). Current tk show renders frontmatter + body as-is; does not synthesize a lineage block. Proposed: compact header listing tier (inferred from body sections), parent ticket (from parent: field), child tickets (tickets whose parent: is this id — requires corpus scan), plan path (from plan: field), epic (from tags). Improves navigation when moving across decomposed work with parent/child chains. Moderate complexity — child discovery requires a corpus scan, similar to what ticket-sidebar does.

