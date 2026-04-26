---
id: tic-wj6s
status: closed
deps: []
links: []
created: 2026-04-26T21:40:15Z
type: task
priority: 1
assignee: Steve Trefethen
parent: tic-zlj5
tags: [epic:agent-coordination]
writes:
  - ~/.claude/hooks/tk-claim-heartbeat.sh
  - ~/.claude/settings.json
---
# Heartbeat hook for Claude — refresh TTL on Stop instead of releasing

## Goal

Replace the now-disabled release-on-Stop with a refresh-on-Stop. Active sessions keep their claims alive indefinitely; abandoned sessions lose claims after 300s TTL.

## Design

Write tk-claim-heartbeat.sh: GET tk:session:SID → ticket_id; SMEMBERS tk:repo:ticket-claims:TICKET → paths; for each path EXPIRE tk:repo:claim:write:PATH 300. Fail-silent (Redis down → no-op). Wire to Stop and SubagentStop in settings.json.

## Acceptance Criteria

Multi-turn Claude session: claim acquired in turn 1, refreshed automatically on turn 2/3/N. Verifiable via redis-cli TTL command — TTL resets to ~300 on every turn end.

## Testing Obligations

Manual: start Claude session on ticket X, edit file, do 3-4 turns of conversation without editing. Check TTL on claim key — should stay >250s. Then close session, wait 5min, claim should be gone.


## Notes

**2026-04-26T21:43:30Z**

tk-claim-heartbeat.sh written, executable, shellcheck clean. End-to-end test: TTL refreshed 100→300 with refreshed=1 in log. Wired to Stop and SubagentStop alongside existing hooks (annotate-dictation-insights, compile-guard) — no replacements, only appended. JSON validates. Will see real heartbeat fire on next turn boundary in /tmp/tk-claim-hook.log.

**2026-04-26T21:43:30Z**

Closed: Smoke test seeded Redis with 100s TTL, fired hook, observed 300s TTL after — heartbeat working as designed. Wired into ~/.claude/settings.json with diff-only-appends.
