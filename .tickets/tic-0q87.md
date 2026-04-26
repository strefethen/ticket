---
id: tic-0q87
status: closed
deps: []
links: []
created: 2026-04-26T21:24:21Z
type: epic
priority: 1
assignee: Steve Trefethen
tags: [epic:backend-opacity]
---
# Backend opacity

## Goal

Make the storage backend opaque to agents. No path leaks in tk output, no $EDITOR-based editing, no agent code reaching into .tickets/. The CLI is the only surface; the format is an implementation detail we can swap.

## Design

Four phases, easiest first: output sanitization, doc reframe, field-level CLI, ticket-edit removal. See plans/current/backend-opacity.md for the full audit surface, decisions, and deferred work. Phase 4 depends on Phase 3.

## Acceptance Criteria

All four child tickets closed. grep -rE '\.tickets|\.md' ticket plugins/ returns only legitimate internal refs. README/CLAUDE.md/AGENTS.md describe storage as implementation detail. ticket-edit no longer exists. CI green.

## Testing Obligations

Per-phase acceptance verified by child ticket testing obligations. Behave scenarios + shellcheck pass on every commit. Manual fresh-agent doc read confirms no storage signal leaks.


## Notes

**2026-04-26T23:23:31Z**

Closed: All 4 phases complete: P1 output sanitization, P2 doc reframe, P3 field-level mutation CLI (set-/append-*), P4 remove ticket-edit. Storage no longer surfaces in tk output, no -based mutation path remains, body sections accept markdown content via dedicated commands. Backend can now be swapped without breaking agent workflows.
