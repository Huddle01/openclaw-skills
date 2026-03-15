---
name: hudl-model-switch
description: Switch between LLM models on the Huddle01 GRU gateway. Use this skill whenever the user mentions switching models, changing models, upgrading, downgrading, "switch to opus", "use minimax", "use claude", "use the smart model", "use the cheap model", "change model", "swap model", or any variation of wanting a different LLM. Also trigger when the user asks "what model am I on", "which model", or "current model". This skill ONLY works with the hudl provider backed by gru.huddle01.io.
---

# hudl-model-switch

Switch the active LLM model for this OpenClaw agent via the Huddle01 GRU gateway.

## Prerequisites

This skill **only works** when the OpenClaw config has a `hudl` provider pointing at `gru.huddle01.io`. If the provider is missing or the baseUrl is different, **stop and tell the user** this skill requires the Huddle01 GRU gateway.

## Step-by-step

### On any hudl-model-switch request

**Step 1: Validate the provider**

Run the validation script:

```bash
bash <skill_dir>/scripts/validate.sh
```

- If it exits 0, proceed.
- If it exits 1, **stop**. Show the user the error message from stdout and do not modify config. Tell them they need the `hudl` provider with `gru.huddle01.io` configured first.

**Step 2: Identify the target model**

Check `<skill_dir>/references/models.md` for the model catalog. Map the user's request to the correct `hudl/`-prefixed model ID.

Key rule: every model going through GRU must be prefixed with `hudl/`. If the user says "opus", the config value is `hudl/claude-opus-4.6`, not `claude-opus-4.6`.

If the user asks for a model not in the catalog, still prefix it with `hudl/` but warn them it needs to exist on GRU or requests will fail.

**Step 3: Edit the config**

1. Read the same OpenClaw config path validated by `scripts/validate.sh`:
   - `~/.openclaw/config.json` (preferred)
   - `~/.openclaw/openclaw.json` (fallback)
   - or `OPENCLAW_CONFIG` if provided
2. Find the current agent's entry in `agents.list` (typically `id: "main"`).
3. Change `agents.list[*].model.primary` for the current agent to the new `hudl/`-prefixed model ID.
4. Also set `agents.defaults.model.primary` to the same `hudl/`-prefixed model ID to keep defaults aligned.
5. Write the file back.

Note: `models.providers.hudl.models` is a provider catalog list, not the active model selector. Do not require it to include the active model for switching to work.

**Do not touch** `baseUrl`, `apiKey`, or unrelated keys.

**Step 4: Restart**

```bash
openclaw restart
```

Tell the user the switch is complete and which model is now active.

### On "what model am I on" / "current model"

1. Run the validation script (Step 1 above).
2. Read the same config path selected by validation (`config.json` or `openclaw.json`).
3. Report:
   - current agent `agents.list[*].model.primary`
   - `agents.defaults.model.primary`
   - and whether they are aligned.

## Example exchanges

**Switch to Opus:**
```
User: switch to opus
Agent: Checking GRU gateway config... verified.
Agent: Switching from hudl/minimax-m2.5 to hudl/claude-opus-4.6.
Agent: *edits config*
Agent: Restarting... done. Now running on hudl/claude-opus-4.6.
```

**No hudl provider:**
```
User: switch to opus
Agent: *runs validate.sh, exits 1*
Agent: This skill requires the Huddle01 GRU gateway (hudl provider with baseUrl gru.huddle01.io) in your OpenClaw config. It's not configured right now. Set up the hudl provider first, then try again.
```

**Unknown model:**
```
User: switch to deepseek-r1
Agent: Heads up -- hudl/deepseek-r1 isn't in the known model catalog. Make sure it exists on your GRU gateway, otherwise requests will fail.
Agent: Switching to hudl/deepseek-r1...
```
