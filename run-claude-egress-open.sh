#!/usr/bin/env bash
set -euo pipefail

# Same as `run-claude-egress-filtered.sh`, but with unrestricted egress:
# layers `compose-egress-open.yml` on top of `compose.yml` to drop the proxy
# and open up `claude-net`, instead of going through the tinyproxy allow-list

# Use a separate external home directory from `run-claude-egress-filtered.sh`,
# so this mode can have its own `CLAUDE.md` and config
export CLAUDE_HOME="$HOME/.claude-sandbox-home-egress-open"
mkdir -p "$CLAUDE_HOME"

# Use the current directory as the project
export PROJECT_DIR="$PWD"

# Set COMPOSE_FILE environment variable, used by `docker compose`
SANDBOX_DIR="$(dirname "$0")"
export COMPOSE_FILE="$SANDBOX_DIR/compose.yml:$SANDBOX_DIR/compose-egress-open.yml"

# Run Claude interactively, forwarding any extra args; skip the proxy using
# `--no-deps` 
docker compose run --rm --no-deps claude claude "$@"
