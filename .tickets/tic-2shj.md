---
id: tic-2shj
status: closed
deps: []
links: []
created: 2026-04-26T21:40:15Z
type: task
priority: 2
assignee: Steve Trefethen
parent: tic-zlj5
tags: [epic:agent-coordination]
writes:
  - plugins/ticket-force-release
---
# tk force-release plugin — recovery for stuck claims

## Goal

Provide a single-command recovery path for claims stuck after a crash, bug, or abandoned session. Distinguishable in the audit stream from normal releases.

## Design

plugins/ticket-force-release. Takes ticket-id OR path. Same Lua as tk release but XADD audit event tagged event=force-release with caller's TK_AGENT_ID. Bypasses any 'is this mine' logic — that's the point.

## Acceptance Criteria

tk force-release <ticket-or-path> clears the claim unconditionally. Audit stream entry has event=force-release. tk audit --event force-release lists recoveries.

## Testing Obligations

Manual: simulate stuck claim (set claim with redis-cli), run tk force-release, confirm DEL succeeded. Verify audit stream entry. shellcheck clean.


## Notes

**2026-04-26T21:48:28Z**

force-release plugin written, executable, shellcheck clean. End-to-end: normal tk release refused (exit 2: held by different ticket), force-release succeeded with audit event=force-release recording original_ticket and forced_by. Idempotent: second call returns 'not held'.

**2026-04-26T21:48:28Z**

Closed: Audit log clearly distinguishes recovery (force-release) from normal flow (release). Verified atomically via single Lua EVAL.
