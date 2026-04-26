---
id: tic-fypi
status: closed
deps: []
links: []
created: 2026-04-26T21:40:15Z
type: bug
priority: 0
assignee: Steve Trefethen
parent: tic-zlj5
tags: [epic:agent-coordination]
writes:
  - ~/.claude/settings.json
---
# Disable broken release-on-Stop in Claude settings (P0)

## Goal

Stop the existing tk-claim-release.sh from firing on every Claude turn boundary, which currently drops all claims constantly during multi-turn work and makes cross-agent protection theatrical.

## Design

Edit ~/.claude/settings.json — remove the Stop and SubagentStop hook entries that point at tk-claim-release.sh. No replacement yet (Phase 1 will add the heartbeat). Claims fall back to 300s TTL cleanup until Phase 1 lands. Save the original block as a backup at ~/.claude/settings.json.bak first.

## Acceptance Criteria

jq '.hooks.Stop' ~/.claude/settings.json no longer references tk-claim-release.sh. SubagentStop same. After this lands, a multi-turn Claude session keeps claims alive across turn boundaries (verified by tailing /tmp/tk-claim-hook.log).

## Testing Obligations

Before/after diff: jq '.hooks | keys' shows expected events. After change, do an Edit, ask a clarifying question (turn boundary), do another Edit — verify claim never released between turns via redis-cli GET on the claim key.


## Notes

**2026-04-26T21:41:27Z**

Stop hook tk-claim-release.sh removed surgically (kept annotate-dictation-insights and compile-guard). SubagentStop now empty array. File validates as JSON. Backup at ~/.claude/settings.json.bak. Claims now fall back to 300s TTL until Phase 1 heartbeat lands.

**2026-04-26T21:41:28Z**

Closed: Verified: jq '.hooks.Stop' shows no tk-claim-release reference; SubagentStop is empty []. JSON validates. Diff was clean (only the targeted lines).
