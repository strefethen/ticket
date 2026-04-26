---
id: tic-zlj5
status: closed
deps: []
links: []
created: 2026-04-26T21:40:15Z
type: epic
priority: 0
assignee: Steve Trefethen
tags: [epic:agent-coordination]
---
# Agent coordination — bulletproof Redis claims across Claude + Codex

## Goal

Multiple AI agents (Claude, Codex) work concurrently without overwriting each other's edits. Universal tk claim/release/audit primitives plus thin per-agent hook layers. Lifecycle correctness (heartbeat instead of release-on-Stop) and cross-agent reach (Codex hooks).

## Design

8 phases sequenced for risk + dependency. Phase 0 ships as P0 fix immediately. See plans/current/agent-coordination.md for full design.

## Acceptance Criteria

Cross-agent integration test passes: Claude on ticket A + Codex on ticket B cannot both write the same file. Audit stream shows acquire→block→release→acquire sequence.

## Testing Obligations

Per-phase acceptance verified by child ticket testing obligations. Manual cross-agent smoke test in Phase 7.


## Notes

**2026-04-26T21:57:27Z**

Closed: All 8 child tickets closed. Lifecycle correctness (heartbeat replaces release-on-Stop, tk complete + tk close auto-release, tk force-release recovery) and cross-agent reach (Codex hook scripts + config wiring) both delivered. Cross-agent integration test passes.
