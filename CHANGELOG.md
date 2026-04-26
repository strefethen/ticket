# Changelog

## [Unreleased]

### Changed
- Extracted `edit`, `ls`, `query`, and `migrate-beads` commands to plugins (ticket-extras)
- `create -d/--description` now emits a `## Goal` section, matching the lint handoff schema.
- `ticket-edit` no longer supports whole-ticket replacement through `--from-file`, non-TTY editor scripts, or `@file` section sources; non-TTY callers must use structured commands and body-section flags instead of treating ticket markdown paths as an automation API.
- `tk close <id>` now releases all held file claims for the ticket as a best-effort side effect (calls `tk complete` first; output silenced — audit stream is the canonical record). Redis being unreachable does not block close.
- Documentation reframe (README, CLAUDE.md, AGENTS.md) no longer exposes internal storage details — drops references to "markdown files in `.tickets/`", YAML frontmatter, the VS Code Cmd+Click file-navigation hint, and `## Goal`-style header naming in the `tk edit` description. Body sections explicitly accept **markdown for formatting** (bullets, code blocks, links, emphasis); the on-disk storage format is now hidden so it can change without breaking agent workflows. `TICKETS_DIR` env var description reframed as "absolute path to the ticket store".

### Added
- `deferred` status value for parking tickets that are valid but not being worked on now. Distinct from `closed` (done) — preserves the "valid work, not done" signal
- `defer <id>` command to set a ticket's status to `deferred` (mirrors `close`)
- `ready` and `blocked` exclude deferred tickets automatically (both use allowlist filter for open/in_progress); `reopen` restores a deferred ticket to open
- `-r, --reason <text>` flag on `status`, `start`, `close`, `defer`, and `reopen`. Appends a timestamped note to the ticket's `## Notes` section with a transition label (`Closed:`, `Deferred:`, `Reopened:`, `Started:`). Multiple transitions preserve full history
- Plugin system: executables named `tk-<cmd>` or `ticket-<cmd>` in PATH are invoked automatically
- `super` command to bypass plugins and run built-in commands directly
- `TICKETS_DIR` and `TK_SCRIPT` environment variables exported for plugins
- `help` command lists installed plugins with descriptions
- Plugin metadata: `# tk-plugin:` comment for scripts, `--tk-describe` flag for binaries
- `create --goal`, `create --testing`, and `create --testing-obligations` flags for generating lint-required handoff sections directly.
- `ticket-edit` body-section flags (`--goal`, `--design`, `--acceptance`, `--testing`) with inline and `@-` stdin values for non-interactive section updates.
- `tk complete <id>` plugin — explicit "I'm done editing files for this ticket" signal. Releases all claims via the per-ticket index. Idempotent. Ticket status unchanged.
- `tk force-release <path>` plugin — recovery for stuck claims (crashed sessions, abandoned tickets). Bypasses ownership check; tags audit event as `force-release` so recovery operations are distinguishable from normal release flow.
- `tk set-goal`, `tk set-design`, `tk set-acceptance`, `tk set-testing` — replace body sections via CLI flags without invoking `$EDITOR`. Section values accept markdown formatting (lists, code blocks, links, emphasis); pass values inline or via `@-` to read from stdin.
- `tk append-design`, `tk append-acceptance` — additive variants that append text to existing sections (or create the section if missing). Same value conventions as set-* commands.

### Fixed
- `ticket-lint` pretty output now runs under macOS system Bash 3.2; Homebrew Bash is no longer required for the default lint path.
- Renamed the writes-scope report plugin from `ticket-status` to `ticket-scope` so bundled plugins no longer shadow the built-in `tk status <id> <status>` mutator.

### Plugins
- ticket-complete 1.0.0: Explicit release of all file claims for a ticket. Companion to `tk close`'s auto-release; useful when you want to release claims but keep the ticket open (e.g., for review).
- ticket-force-release 1.0.0: Stuck-claim recovery. Releases unconditionally and tags the audit stream with `event=force-release` to distinguish from normal flow.
- ticket-edit 1.5.0: Open or update ticket sections; removed `--from-file`, non-TTY editor scripts, and `@file` section sources so automation updates tickets only through structured flags with inline or `@-` values
- ticket-lint 0.5.1: Validate handoff schema; fixed Bash 3.2 compatibility for pretty output
- ticket-ls 1.0.0: List tickets with optional filters (extracted from core); `ticket-list` symlink for alias
- ticket-query 1.0.0: Output tickets as JSON, optionally filtered with jq (extracted from core)
- ticket-migrate-beads 1.0.0: Import tickets from .beads/issues.jsonl (extracted from core)
- ticket-scope 1.0.0: Show git-modified files classified by ticket `writes:` scope. `writes:` entries may be glob patterns (e.g. `packages/frontend/**`, `**/*.ts`). Bash `[[ ]]` pattern matching — `*` and `**` both match across `/`, `?` matches one char, `[abc]` matches a class. Literal paths still work as exact match. Reframes `writes:` from "every file I will edit" to "the zone I will edit in" — more compact, less brittle to legitimate refactors within a declared boundary

## [0.3.2] - 2026-02-03

### Fixed
- Ticket ID lookup now trims leading/trailing whitespace (fixes issue with AI agents passing extra spaces)

## [0.3.1] - 2026-01-28

### Added
- `list` command alias for `ls`
- `TICKET_PAGER` environment variable for `show` command (only when stdout is a TTY; falls back to `PAGER`)

### Changed
- Walk parent directories to find `.tickets/` directory, enabling commands from any subdirectory
- Ticket ID suffix now uses full alphanumeric (a-z0-9) instead of hex for increased entropy

### Fixed
- `dep` command now resolves partial IDs for the dependency argument
- `undep` command now resolves partial IDs and validates dependency exists
- `unlink` command now resolves partial IDs for both arguments
- `create --parent` now validates and resolves parent ticket ID
- `generate_id` now uses 3-char prefix for single-segment directory names (e.g., "plan" → "pla" instead of "p")

## [0.3.0] - 2026-01-18

### Added
- Support `TICKETS_DIR` environment variable for custom tickets directory location
- `dep cycle` command to detect dependency cycles in open tickets
- `add-note` command for appending timestamped notes to tickets
- `-a, --assignee` filter flag for `ls`, `ready`, `blocked`, and `closed` commands
- `--tags` flag for `create` command to add comma-separated tags
- `-T, --tag` filter flag for `ls`, `ready`, `blocked`, and `closed` commands

## [0.2.0] - 2026-01-04

### Added
- `--parent` flag for `create` command to set parent ticket
- `link`/`unlink` commands for symmetric ticket relationships
- `show` command displays parent title and linked tickets
- `migrate-beads` now imports parent-child and related dependencies

## [0.1.1] - 2026-01-02

### Fixed
- `edit` command no longer hangs when run in non-TTY environments

## [0.1.0] - 2026-01-02

Initial release.
