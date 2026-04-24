---
id: tlf-p8g4
status: open
deps: []
links: []
created: 2026-04-24T22:00:33Z
type: task
priority: 3
assignee: Steve Trefethen
tags: [epic:tk-tooling]
---
# Promote scope-expansion from note-pattern to first-class status

Migrated 2026-04-24 from fullstack-starter/fs-55lt (wrong repo home — this is tk-core work, not fullstack-starter work).

Codex feedback (2026-04-24). Current protocol (ticket-writer skill, 2026-04-24): when an agent hits scope boundaries, run tk add-note <id> 'Scope expansion requested: <paths>. Reason: <why>.' and pause for caller approval. Upgrade path if note-pattern proves insufficient in real use: a first-class status (e.g. needs-scope-expansion) or command (tk block <id> -r '<reason>') so tk ready / tk blocked surface scope-pauses distinctly from dep-blocked. Trigger: note-pattern friction accumulates — hard to filter, hard to audit, agents forget to run.

