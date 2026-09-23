#!/usr/bin/env bash
set -euo pipefail

# Use a dedicated external home directory and make sure it exists
export CLAUDE_HOME="$HOME/.claude-sandbox-home-egress-filtered"
mkdir -p "$CLAUDE_HOME"

# Use the current directory as the project
export PROJECT_DIR="$PWD"

# Set COMPOSE_FILE environment variable, used by `docker compose`
SANDBOX_DIR="$(dirname "$0")"
export COMPOSE_FILE="$SANDBOX_DIR/compose.yml"

# Make sure proxy is running
docker compose up -d proxy

# Run Claude interactively, forwarding any extra args
docker compose run --rm claude claude "$@"
