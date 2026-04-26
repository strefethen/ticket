# Ticket Plugins

Official plugins that extend `tk` with additional commands.

## Writing Plugins

Plugins are executables named `tk-<cmd>` or `ticket-<cmd>` in `$PATH`. This repo uses the `ticket-` prefix for consistency.

Official plugins in this repo must not reuse a built-in command name. Keep core
commands such as `status`, `create`, and `close` owned by the main `ticket`
script; choose a distinct plugin command such as `scope` for adjacent workflows.

Required metadata in the first 10 lines:

```bash
#!/usr/bin/env bash
# tk-plugin: sync tickets with GitHub issues
# tk-plugin-version: 1.0.0

set -euo pipefail
# implementation here
```

## Environment Variables

Plugins receive:
- `TICKETS_DIR` — absolute path to `.tickets/` directory
- `TK_SCRIPT` — absolute path to the `tk` script

Use `$TK_SCRIPT super <cmd>` to call built-ins without recursing into plugins:

```bash
#!/usr/bin/env bash
# tk-plugin: wrapper that creates tickets with defaults
# tk-plugin-version: 1.0.0

"$TK_SCRIPT" super create "$@" --type task --priority 1
```

## Non-Interactive Editing

`tk edit <id>` opens `$EDITOR` only in an interactive terminal. In non-TTY
automation, callers must pass section flags. The plugin does not expose the
ticket file path or run editor scripts as an automation API.

For handoff body updates, prefer section flags so automation does not need to
know or assemble the underlying ticket file format:

```bash
tk edit abc-1234 --design "Use the existing parser path"
printf '%s\n' "- Parser accepts the new flag" | tk edit abc-1234 --acceptance @-
```

Section flags mirror `tk create`: `-d`/`--description`/`--goal`, `--design`,
`--acceptance`, and `--testing`/`--testing-obligations`. Values may be inline
text or `@-` for stdin. Only one section flag may read from stdin per command.
Generated automation content should prefer `@-`. Do not create temporary ticket
markdown or section files for replacement.

## Packaging

Plugins here are automatically packaged on release for Homebrew and AUR.

**Meta-packages:**
- `ticket-core` — core script only
- `ticket-extras` — curated plugins (listed in `pkg/extras.txt`)
- `ticket` — depends on core + extras

**Install options:**
```bash
brew install ticket                      # Full: core + curated plugins
brew install ticket-core                 # Minimal: core only
brew install ticket-core ticket-query    # Core + specific plugin
```

## Adding a Plugin

1. Create `plugins/ticket-<name>` with metadata comments
2. `chmod +x plugins/ticket-<name>`
3. Add to `pkg/extras.txt` if it should be in the extras bundle
4. Commit and tag a release
