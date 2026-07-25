#!/usr/bin/env bash
# Start the MCP Supabase server
# Usage: ./start.sh
# Requires SUPABASE_URL and SUPABASE_KEY environment variables
# or a .env file in this directory.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load .env if it exists
if [ -f "$SCRIPT_DIR/.env" ]; then
  set -a
  source "$SCRIPT_DIR/.env"
  set +a
fi

if [ -z "${SUPABASE_URL:-}" ] || [ -z "${SUPABASE_KEY:-}" ]; then
  echo "Error: SUPABASE_URL and SUPABASE_KEY must be set."
  echo "Copy .env.example to .env and fill in the values."
  exit 1
fi

export SUPABASE_URL
export SUPABASE_KEY

exec node "$SCRIPT_DIR/dist/index.js"
