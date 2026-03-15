#!/usr/bin/env bash
# validate.sh -- Check that the hudl provider exists and points at gru.huddle01.io
# Exit 0 = good to go, Exit 1 = missing or misconfigured

set -euo pipefail

CONFIG_CANDIDATES=(
  "${OPENCLAW_CONFIG:-}"
  "$HOME/.openclaw/config.json"
  "$HOME/.openclaw/openclaw.json"
)

CONFIG=""
for candidate in "${CONFIG_CANDIDATES[@]}"; do
  if [ -n "$candidate" ] && [ -f "$candidate" ]; then
    CONFIG="$candidate"
    break
  fi
done

# Check config exists
if [ -z "$CONFIG" ]; then
  echo "ERROR: OpenClaw config not found."
  echo "Checked: $HOME/.openclaw/config.json and $HOME/.openclaw/openclaw.json"
  echo "Tip: set OPENCLAW_CONFIG=/path/to/your/config.json if your config is elsewhere."
  exit 1
fi

# Check jq is available
if ! command -v jq &>/dev/null; then
  echo "ERROR: jq is required but not installed. Install it with: sudo apt install jq"
  exit 1
fi

# Check hudl provider exists
PROVIDER=$(jq -r '.models.providers.hudl // empty' "$CONFIG")
if [ -z "$PROVIDER" ]; then
  echo "ERROR: No 'hudl' provider found in config. Add a hudl provider with baseUrl https://gru.huddle01.io to use this skill."
  exit 1
fi

# Check baseUrl matches gru.huddle01.io
BASE_URL=$(jq -r '.models.providers.hudl.baseUrl // empty' "$CONFIG")
if [[ "$BASE_URL" != *"gru.huddle01.io"* ]]; then
  echo "ERROR: hudl provider baseUrl is '$BASE_URL', expected 'https://gru.huddle01.io'. This skill only works with the Huddle01 GRU gateway."
  exit 1
fi

# Check apiKey is set
API_KEY=$(jq -r '.models.providers.hudl.apiKey // empty' "$CONFIG")
if [ -z "$API_KEY" ]; then
  echo "ERROR: hudl provider has no apiKey set. Add your GRU gateway API key to the hudl provider config."
  exit 1
fi

echo "OK: hudl provider verified (config: $CONFIG, baseUrl: $BASE_URL)"
exit 0
