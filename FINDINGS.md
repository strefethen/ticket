# FINDINGS

Out-of-scope issues discovered during other work. Per global Discovery Protocol: log here, name severity, do not act unless redirected.

Severity scale: P0 = security/data loss · P1 = broken functionality · P2 = degraded behavior · P3 = tech debt.

---

## 2026-04-24

- **P2 — Behave suite has 9 failing scenarios on `local-fixes` baseline** — pre-existing before glob-support change. All failures are in `features/ticket_status.feature` (and one in `id_resolution.feature`) for the **core** `tk status <id> <status>` command. Likely cause: the local `ticket-status` plugin (drift detector) shadows the built-in `status` dispatch when invoked via `ticket status <id> <arg>`, so the test calls land in the plugin instead of the core command. Reproduction: `cd ~/github/ticket-local-fixes && make test`. Locations: `features/ticket_status.feature:10,16,22,48,54,59,64,113` and `features/id_resolution.feature:53`. Means CI signal on this branch is broken — real regressions could hide behind the same nine red marks.
