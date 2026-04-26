# ticket

> **Status:** Opinionated personal fork of [`wedow/ticket`](https://github.com/wedow/ticket).
> Upstream appears unmaintained as of April 2026; this fork is maintained as a working tool
> and is **not accepting external contributions**. The upstream relationship is preserved so
> cherry-picks can flow downstream if maintenance resumes — but no work from this fork is
> sent back upstream.

The git-backed issue tracker for AI agents. Rooted in the Unix Philosophy, `tk` is inspired by Joe Armstrong's [Minimal Viable Program](https://joearms.github.io/published/2014-06-25-minimal-viable-program.html) with additional quality of life features for managing and querying against complex issue dependency graphs.

`tk` was written as a full replacement for [beads](https://github.com/steveyegge/beads). It shares many similar commands but without the need for keeping a SQLite file in sync or a rogue background daemon mangling your changes. It ships with a `migrate-beads` command to make this a smooth transition.

## Why this fork

A few opinions that shape this fork beyond what upstream provides:

- **Agent-first.** Designed primarily for AI agents (Claude Code, Codex), not interactive humans. `CLAUDE.md` and `AGENTS.md` are first-class artifacts.
- **Backend opacity.** Storage is sealed — agents interact only through the `tk` CLI. No `$EDITOR`, no file paths in output, no direct file access. Body fields accept **markdown** for formatting (bullets, code blocks, links, emphasis); the on-disk *storage* format is hidden so it can change. This frees the project to evolve the backend without breaking agent workflows.
- **Redis-coordinated file claims.** Plugins (`tk claim`, `tk release`, `tk check`, `tk audit`) provide cross-agent file reservation so multiple agents working concurrently don't overwrite each other's edits. Lua-atomic acquire/release with a per-ticket index for enumeration.
- **Consolidated plugin suite.** Plugins that previously lived across multiple repos (`ticket-claim`, `ticket-release`, `ticket-audit`, `ticket-check`, `ticket-epics`, `ticket-lint`, `ticket-scope`, `ticket-work-on`/`work-off`, `ticket-query-docs`, `ticket-sidebar`) all ship from `plugins/` in this tree.
- **CI for verification, not distribution.** GitHub Actions run Behave tests and `shellcheck` on every push and pull request. No Homebrew tap, no AUR — install from source.

Ticket IDs (e.g., `nw-5c46`) appear in commit messages and `tk` output as the durable handle for any ticket. Pass an ID to commands like `tk show`, `tk start`, `tk close` — `tk` resolves partial IDs, so `tk show 5c46` works once the prefix is unique.

## Install

**From source (auto-updates on git pull):**
```bash
git clone https://github.com/strefethen/ticket.git
cd ticket && ln -s "$PWD/ticket" ~/.local/bin/tk
```

**Or** just copy `ticket` to somewhere in your PATH.

## Requirements

`tk` is a portable bash script requiring only coreutils, so it works out of the box on any POSIX system with bash 3.2+ installed. Bundled plugins target the macOS system Bash as well; plugin JSON modes and the `query` command require `jq`. Uses `rg` (ripgrep) if available, falls back to `grep`.

## Agent Setup

Add this line to your `CLAUDE.md` or `AGENTS.md`:

```
This project uses a CLI ticket system for task management. Run `tk help` when you need to use it.
```

Claude Opus picks it up naturally from there. Other models may need additional guidance.

## Usage

```bash
tk - minimal ticket system with dependency tracking

Usage: tk <command> [args]

Commands:
  create [title] [options] Create ticket, prints ID
    -d, --description      Goal text
    --goal                 Goal text (alias for --description)
    --design               Design notes
    --acceptance           Acceptance criteria
    --testing              Testing obligations
    --testing-obligations  Testing obligations (alias for --testing)
    -t, --type             Type (bug|feature|task|epic|chore) [default: task]
    -p, --priority         Priority 0-4, 0=highest [default: 2]
    -a, --assignee         Assignee [default: git user.name]
    --external-ref         External reference (e.g., gh-123, JIRA-456)
    --parent               Parent ticket ID
    --tags                 Comma-separated tags (e.g., --tags ui,backend,urgent)
    --plan                 Relative path to a planning doc (traceability)
    --writes               Comma-separated paths the agent will edit (block sequence)
    --reads                Comma-separated paths the agent will read for context
    --supersedes           Comma-separated ticket ids this ticket replaces
  start <id> [-r reason]   Set status to in_progress (optional reason note)
  close <id> [-r reason]   Set status to closed (optional reason note)
  defer <id> [-r reason]   Set status to deferred (optional reason note)
  reopen <id> [-r reason]  Set status to open (optional reason note)
  status <id> <status> [-r reason]  Update status (open|in_progress|closed|deferred)
  dep <id> <dep-id>        Add dependency (id depends on dep-id)
  dep tree [--full] <id>   Show dependency tree (--full disables dedup)
  dep cycle                Find dependency cycles in open tickets
  undep <id> <dep-id>      Remove dependency
  link <id> <id> [id...]   Link tickets together (symmetric)
  unlink <id> <target-id>  Remove link between tickets
  ready [-a X] [-T X]      List open/in-progress tickets with deps resolved
  blocked [-a X] [-T X]    List open/in-progress tickets with unresolved deps
  closed [--limit=N] [-a X] [-T X] List recently closed tickets (default 20, by mtime)
  show <id>                Display ticket
  add-note <id> [text]     Append timestamped note (or pipe via stdin)
  set-goal <id> <value>    Replace the Goal section (value or @- for stdin)
  set-design <id> <value>  Replace the Design section
  set-acceptance <id> <value>      Replace the Acceptance Criteria section
  set-testing <id> <value> Replace the Testing Obligations section
  append-design <id> <value>       Append text to the Design section
  append-acceptance <id> <value>   Append text to the Acceptance Criteria section
  super <cmd> [args]       Bypass plugins, run built-in command directly

Body section values accept markdown for formatting (lists, code blocks,
links, emphasis). Use @- to read the value from stdin.

Plugins (tk-<cmd> or ticket-<cmd> in PATH):
  audit                  View the tk:<repo>:audit:claims Redis stream
  check                  Check who holds the claim on a file path (if anyone)
  claim                  Acquire a write claim on a file path via Redis
  complete               Release all file claims for a ticket (work-done signal)
  epics                  List epic tags used in the current repo's tickets
  force-release          Force-release a stuck file claim (recovery for crashed sessions)
  lint                   Validate tickets against the handoff schema
  list                   List tickets with optional filters
  ls                     List tickets with optional filters
  query                  Output tickets as JSON, optionally filtered with jq
  query-docs             Full-text search across ticket bodies (Design, Acceptance, descriptions)
  release                Release a write claim on a file path
  scope                  Show git-modified files classified by ticket writes: scope
  sidebar                Generate _sidebar.json for the fullstack-starter docs engine
  work-off               Clear the active ticket for this repo
  work-on                Set the active ticket for this repo

Use 'super' to bypass plugins. Plugin authoring: see plugins/README.md.

Plugin descriptions: comment '# tk-plugin: text' or --tk-describe flag

Supports partial ID matching (e.g., 'tk show 5c4' matches 'nw-5c46')
```

## Plugins

Executables named `tk-<cmd>` or `ticket-<cmd>` in your PATH are invoked automatically. This allows you to add custom commands or override built-in ones.

```bash
# Create a simple plugin
cat > ~/.local/bin/tk-hello <<'EOF'
#!/bin/bash
# tk-plugin: Say hello
echo "Hello from plugin!"
EOF
chmod +x ~/.local/bin/tk-hello

# Now it's available
tk hello        # runs tk-hello
tk help         # lists it under "Plugins"
```

**Plugin descriptions** (shown in `tk help`):
- Scripts: comment `# tk-plugin: description` in first 10 lines
- Binaries: `--tk-describe` flag outputs `tk-plugin: description`

**Plugin environment variables:**
- `TICKETS_DIR` - absolute path to the ticket store (may be empty)
- `TK_SCRIPT` - absolute path to the tk script

**Calling built-ins from plugins:**
```bash
#!/bin/bash
# tk-plugin: Custom create with extras
id=$("$TK_SCRIPT" super create "$@")
echo "Created $id, doing extra stuff..."
```

Use `tk super <cmd>` to bypass plugins and run the built-in directly.

## Testing

The tests are written in the Behavior-Driven Development library [behave](https://behave.readthedocs.io/en/latest/) and require Python.

If you have `uv` [installed](https://docs.astral.sh/uv/getting-started/installation/) simply:

```sh
make test
```

## Migrating from Beads

```bash
tk migrate-beads

# review new files if you like
git status

# check state matches expectations
tk ready
tk blocked

# compare against
bd ready
bd blocked

# all good, let's go
git rm -rf .beads
git add .tickets
git commit -am "ditch beads"
```

For a thorough system-wide Beads cleanup, see [banteg's uninstall script](https://gist.github.com/banteg/1a539b88b3c8945cd71e4b958f319d8d).

## License

MIT
