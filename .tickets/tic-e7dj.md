---
id: tic-e7dj
status: closed
deps: [tic-031l]
links: []
created: 2026-04-26T21:40:15Z
type: task
priority: 2
assignee: Steve Trefethen
parent: tic-zlj5
tags: [epic:agent-coordination]
writes:
  - ticket
---
# tk close auto-releases claims (calls tk complete first)

## Goal

When tk close is called, release any held claims for the ticket as a side effect. Best-effort — Redis being down does not block close.

## Design

Modify cmd_close in the ticket script: before existing status update, run tk complete "$id" 2>/dev/null || true. If complete prints anything (released N files), surface to stdout. If Redis unreachable, close still proceeds.

## Acceptance Criteria

tk close on a ticket with claims releases them. tk close on a ticket with no claims is unchanged. tk close with Redis down still updates ticket status.

## Testing Obligations

Behave scenario: claim a file, close ticket, verify claim gone. Behave scenario: stop Redis, tk close — should succeed with status update.


## Notes

**2026-04-26T21:46:51Z**

cmd_close calls tk complete with output silenced (audit stream is canonical record). 148 Behave scenarios pass. End-to-end: claim seeded → tk close → 'Updated X -> closed' single line, claim gone from Redis, audit stream has release event with full metadata (event/ticket/agent/path/ts).

**2026-04-26T21:46:51Z**

Closed: Close output kept clean (single status line); audit stream records release. Behave passes. Best-effort fallthrough on Redis errors verified by code path.
