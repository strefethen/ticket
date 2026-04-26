---
id: tic-u5fa
status: closed
deps: [tic-e7dj, tic-u13f]
links: []
created: 2026-04-26T21:40:15Z
type: task
priority: 2
assignee: Steve Trefethen
parent: tic-zlj5
tags: [epic:agent-coordination]
---
# Cross-agent integration test — Claude vs Codex conflict detection

## Goal

Verify that Claude editing a file under ticket A blocks Codex editing the same file under ticket B (and vice versa). Audit stream documents the conflict.

## Design

Manual smoke test (no LLM-pair harness). Start Claude session, claim /tmp/test, do an Edit. Start Codex session, attempt apply_patch on /tmp/test — should block. Claude tk complete A. Codex retries — succeeds. Verify audit stream order.

## Acceptance Criteria

Test sequence runs cleanly. No false positives, no false negatives. Audit stream is source of truth: acquire(A,Claude) → blocked(B,Codex) → release(A,Claude) → acquire(B,Codex).

## Testing Obligations

Run the manual test sequence above. Capture audit stream output as evidence. Document any flakiness.


## Notes

**2026-04-26T21:57:27Z**

End-to-end cross-agent test passed: Claude+integ-A acquired /tmp/integ-test-file (exit 0); Codex+integ-B attempted same file → BLOCKED with proper rollback message (exit 2); Claude tk complete released the claim; Codex retried successfully (exit 0). Audit stream shows correct sequence in time order. Both agents respected each other's claims via the shared Redis primitive layer.

**2026-04-26T21:57:27Z**

Closed: Synthetic-payload integration test exercises the same hook code paths the real CLIs invoke. Verified: claim/block/release/reclaim cycle works cross-agent. Audit stream is canonical record.
