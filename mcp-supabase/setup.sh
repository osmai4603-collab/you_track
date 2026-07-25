#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  YouTrack Supabase Setup${NC}"
echo -e "${GREEN}========================================${NC}"

# Load .env
if [ -f "$SCRIPT_DIR/.env" ]; then
  set -a
  source "$SCRIPT_DIR/.env"
  set +a
  echo -e "${GREEN}✓ .env file loaded${NC}"
else
  echo -e "${YELLOW}⚠ No .env file found. Creating from .env.example...${NC}"
  cp "$SCRIPT_DIR/.env.example" "$SCRIPT_DIR/.env"
  echo -e "${YELLOW}  Please edit mcp-supabase/.env with your service_role key.${NC}"
  echo -e "${YELLOW}  Get it from: Supabase Dashboard → Project Settings → API${NC}"
  exit 1
fi

if [ -z "${SUPABASE_URL:-}" ] || [ -z "${SUPABASE_KEY:-}" ]; then
  echo -e "${RED}✗ SUPABASE_URL and SUPABASE_KEY must be set in .env${NC}"
  exit 1
fi

echo -e "${GREEN}✓ Supabase URL: ${SUPABASE_URL}${NC}"

# Check key type
if echo "$SUPABASE_KEY" | grep -q "service_role"; then
  echo -e "${GREEN}✓ Using service_role key (bypasses RLS)${NC}"
else
  echo -e "${YELLOW}⚠ Using anon key - data insertion may fail due to RLS${NC}"
  echo -e "${YELLOW}  Recommend using service_role key for full access${NC}"
fi

# Check Node.js deps
echo -e "\n${GREEN}--- Checking dependencies ---${NC}"
if [ ! -d "$SCRIPT_DIR/node_modules" ]; then
  echo "Installing dependencies..."
  npm install --prefix "$SCRIPT_DIR"
fi
echo -e "${GREEN}✓ Dependencies installed${NC}"

# Build TypeScript
echo -e "\n${GREEN}--- Building MCP Server ---${NC}"
npx tsc --project "$SCRIPT_DIR/tsconfig.json"
echo -e "${GREEN}✓ MCP Server built${NC}"

# Apply migrations via seed
echo -e "\n${GREEN}--- Running Seed Script ---${NC}"
echo -e "${YELLOW}This will insert sample data into: projects, project_members, issues, settings${NC}"
echo -e "${YELLOW}Press Enter to continue or Ctrl+C to cancel...${NC}"
read -r

export SUPABASE_URL SUPABASE_KEY
npx tsx "$SCRIPT_DIR/src/seed.ts"

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}  Setup complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e ""
echo -e "Next steps:"
echo -e "1. Set SUPABASE_URL and SUPABASE_KEY in your environment"
echo -e "2. Restart opencode to load the MCP server"
echo -e "3. Use MCP tools to interact with your data"
echo -e ""
echo -e "Available MCP tools:"
echo -e "  list_projects, create_project, update_project, delete_project"
echo -e "  list_issues, create_issue, update_issue, delete_issue"
echo -e "  list_settings, set_setting, get_setting"
echo -e "  list_project_members, add_project_member"
