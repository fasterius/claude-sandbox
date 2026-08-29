#!/usr/bin/env bash
set -euo pipefail

# Make sure the external home directory exists
mkdir -p "$HOME/.claude-sandbox-home"

# Use the current directory as the project
export PROJECT_DIR="$PWD"

# Set COMPOSE_FILE environment variable, used by `docker compose`
SANDBOX_DIR="$(dirname "$0")"
export COMPOSE_FILE="$SANDBOX_DIR/compose.yml"

# Make sure proxy is running
docker compose up -d proxy

# Run Claude interactively, forwarding any extra args
docker compose run --rm claude claude "$@"
