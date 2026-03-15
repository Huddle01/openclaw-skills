# Makefile for Hudl Model Switch Skill

# --- Configuration ---
SKILL_DIR   := .
SLUG        := hudl-model-switch
NAME        := "Hudl AI Openclaw Model Switch"
MAJOR       := 1
MINOR := 0
PATCH := 3
VERSION     = $(shell grep '^MAJOR' Makefile | awk '{print $$3}').$(shell grep '^MINOR' Makefile | awk '{print $$3}').$(shell grep '^PATCH' Makefile | awk '{print $$3}')
DESCRIPTION := "Switch between 30+ LLM models when using Hudl AI inside Openclaw. Just say 'switch to opus' or 'use deepseek' in chat."
TAGS        := "llm,ai-inference,huddle01,huddle01-cloud,model-switching,huddle01,gru,openclaw"
CHANGELOG   := "Initial release with 30+ models across OpenAI, Anthropic, Google, DeepSeek, xAI, Qwen, MiniMax, Moonshot, Meta, Mistral"

.PHONY: help version latest-version set-version publish update patch pack clean bump bump-major bump-patch

help: ## Show this help menu
	@echo "Usage: make [target]"
	@echo ""
	@echo "Current Version: $(VERSION)"
	@echo ""
	@echo "Available targets:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

version latest-version: ## Show the latest version in a readable format
	@echo "Latest version: $(VERSION)"
	@echo "  major: $(MAJOR)"
	@echo "  minor: $(MINOR)"
	@echo "  patch: $(PATCH)"

set-version: ## Set version directly (usage: make set-version VERSION=1.2.3)
	@if [ -z "$(VERSION)" ]; then echo "❌ Missing VERSION. Use: make set-version VERSION=1.2.3"; exit 1; fi
	@if ! echo "$(VERSION)" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$$'; then echo "❌ Invalid VERSION '$(VERSION)'. Expected format: X.Y.Z"; exit 1; fi
	@echo "🔄 Setting version to $(VERSION)..."
	@v="$(VERSION)"; \
	major=$$(echo "$$v" | cut -d. -f1); \
	minor=$$(echo "$$v" | cut -d. -f2); \
	patch=$$(echo "$$v" | cut -d. -f3); \
	awk -v major="$$major" -v minor="$$minor" -v patch="$$patch" '\
	/^MAJOR[[:space:]]*:=|^MAJOR[[:space:]]*=/ {sub(/[0-9]+$$/, major)} \
	/^MINOR[[:space:]]*:=|^MINOR[[:space:]]*=/ {sub(/[0-9]+$$/, minor)} \
	/^PATCH[[:space:]]*:=|^PATCH[[:space:]]*=/ {sub(/[0-9]+$$/, patch)} \
	{print}' Makefile > Makefile.tmp && mv Makefile.tmp Makefile
	@$(MAKE) --no-print-directory version

bump-major: ## Bump the major version (e.g., 1.2.3 -> 2.0.0)
	@echo "🚀 Bumping MAJOR version..."
	@awk '/^MAJOR/{$$3++; print; next} /^MINOR/{$$3=0; print; next} /^PATCH/{$$3=0; print; next}1' Makefile > Makefile.tmp && mv Makefile.tmp Makefile
	@echo "✅ Version bumped to $(VERSION)"

bump: ## Bump the minor version (e.g., 1.0.0 -> 1.1.0)
	@echo "🚀 Bumping MINOR version..."
	@awk '/^MINOR/{$$3++; print; next} /^PATCH/{$$3=0; print; next}1' Makefile > Makefile.tmp && mv Makefile.tmp Makefile
	@echo "✅ Version bumped to $(VERSION)"

bump-patch: ## Bump the patch version (e.g., 1.0.0 -> 1.0.1)
	@echo "🚀 Bumping PATCH version..."
	@awk '/^PATCH/{$$3++; print; next}1' Makefile > Makefile.tmp && mv Makefile.tmp Makefile
	@echo "✅ Version bumped to $(VERSION)"

publish: ## Publish the skill to ClawHub
	@echo "🚀 Publishing $(NAME) version $(VERSION) to ClawHub..."
	clawhub publish $(SKILL_DIR) \
		--slug $(SLUG) \
		--name $(NAME) \
		--version $(VERSION) \
		--tags $(TAGS) \
		--changelog $(CHANGELOG)

update: publish ## Update the skill on ClawHub (alias for publish)

patch: bump-patch publish ## Bump patch version and publish to ClawHub

pack: ## Create a distributable zip archive of the skill
	@echo "📦 Packing $(SLUG)-$(VERSION).zip..."
	zip -r $(SLUG)-$(VERSION).zip . -x "*.git*" "*.zip" ".DS_Store"

clean: ## Clean up any build artifacts
	@echo "🧹 Cleaning up..."
	rm -f *.zip
