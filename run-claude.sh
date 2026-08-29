#!/usr/bin/env bash
set -euo pipefail

# Use the current directory as the project
export PROJECT_DIR="$PWD"

# Move to the sandbox setup directory so compose finds its files
cd "$(dirname "$0")"

# Make sure the external state directory exists, owned by the invoking user
mkdir -p "$HOME/.claude-sandbox-home"

# Make sure proxy is running
docker compose up -d proxy

# Run Claude interactively
docker compose run --rm claude claude
