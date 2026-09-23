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

# Set COMPOSE_FILE and COMPOSE_PROJECT_NAME, used by `docker compose`; the
# project name must differ from the egress-filtered mode's so they get
# separate networks/containers instead of clashing over shared ones
SANDBOX_DIR="$(dirname "$0")"
export COMPOSE_FILE="$SANDBOX_DIR/compose.yml:$SANDBOX_DIR/compose-egress-open.yml"
export COMPOSE_PROJECT_NAME="claude-sandbox-egress-open"

# Run Claude interactively, forwarding any extra args; skip the proxy using
# `--no-deps` 
docker compose run --rm --no-deps claude claude "$@"
