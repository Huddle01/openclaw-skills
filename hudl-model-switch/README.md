# hudl-model-switch

An OpenClaw skill for switching between 29 LLM models on the [Huddle01 GRU gateway](https://gru.huddle01.io).

## What it does

Lets you switch your OpenClaw agent's model by just asking in chat:

- "switch to opus"
- "use grok"
- "go back to minimax"
- "use deepseek r1"
- "switch to gemini pro"
- "what model am I on?"

The skill validates your GRU gateway config, edits your OpenClaw config, and restarts the agent automatically.

## Requirements

- OpenClaw with a `hudl` provider configured pointing at `https://gru.huddle01.io`
- A valid GRU gateway API key
- `jq` installed on the system

## Install

```bash
# Clone into your OpenClaw skills directory
git clone https://github.com/huddle01/openclaw-skills.git
cp -r openclaw-skills/hudl-model-switch ~/.openclaw/skills/hudl-model-switch

# Or if using clawhub
clawhub install hudl-model-switch
```

Then restart OpenClaw.

## Supported models (29)

| Provider | Models |
|---|---|
| OpenAI | gpt-5.4, gpt-5.4-pro, gpt-4.1, gpt-4.1-mini, gpt-4.1-nano, o3, o4-mini, gpt-4o-mini |
| Anthropic | claude-opus-4.6, claude-sonnet-4.6, claude-sonnet-4.5, claude-haiku-4.5, claude-sonnet-4 |
| Google | gemini-3.1-pro, gemini-3.1-flash-lite, gemini-2.5-pro, gemini-2.5-flash |
| DeepSeek | deepseek-v3.2, deepseek-r1 |
| xAI | grok-4.1-fast, grok-3-mini |
| Qwen | qwen3-235b, qwen-2.5-coder-32b |
| MiniMax | minimax-m2.5 |
| Moonshot | kimi-k2.5 |
| Meta | llama-4-maverick, llama-3.3-70b |
| Mistral | mistral-large, codestral |

All models are automatically prefixed with `hudl/` in the config.

## Structure

```
hudl-model-switch/
├── SKILL.md              # Main skill instructions
├── scripts/
│   └── validate.sh       # Checks hudl provider config before any switch
├── references/
│   └── models.md         # Full model catalog with aliases
└── README.md
```

## How it works

1. User says "switch to opus"
2. Skill runs `validate.sh` to confirm `hudl` provider with `gru.huddle01.io` exists
3. Maps "opus" to `hudl/claude-opus-4.6` using the model catalog
4. Edits `~/.openclaw/config.json` (only `model.primary`, nothing else)
5. Runs `openclaw restart`

If the hudl provider isn't configured, the skill refuses to proceed and tells the user what's missing.