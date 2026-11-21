# Dotfiles for this laptop. See AGENTS.md.
# bootstrap.sh is still the first step on a new Mac: make needs the Command Line Tools it installs, and it ends with make all.
# Kept to GNU Make 3.81 features, the version older Macs have.

SHELL := /bin/bash

# Install order for make all. Every module after packages needs something it installed
MODULES := packages     # Brewfile or Portlist, from the profile's PACKAGE_MANAGER
MODULES += zsh          # Login shell and zsh config. Reads the abbreviations in modules/fish/
MODULES += fish         # Previous shell's config, kept working
MODULES += git          # Config and the SSH signing key setup
MODULES += tmux         # Clones tpm
MODULES += nvim
MODULES += bin
MODULES += claude
MODULES += duti         # Default apps, needs the apps installed by packages
MODULES += macos
MODULES += key-mappings
MODULES += hammerspoon  # Skips itself when Hammerspoon is not installed
MODULES += ghostty      # Likewise
MODULES += iterm2       # Likewise. Also copies the Nerd Font symbols that packages installed
MODULES += vscode       # Likewise

# What make status covers. macos has no dry run yet (see TODO/TODO.txt)
DRY_RUN_MODULES := $(filter-out macos,$(MODULES))

# None of these are files (shortcuts is a directory), so make has to run them every time
.PHONY: help all status profile shortcuts $(MODULES) $(addprefix status-,$(DRY_RUN_MODULES))

# setup.sh scripts ask for sudo, so never run them in parallel
.NOTPARALLEL:

help:
	@grep -E '^[a-z-]+:.*## ' $(MAKEFILE_LIST) | awk -F':.*## ' '{printf "  %-18s %s\n", $$1, $$2}'
	@printf "  %-18s %s\n" "<module>" "Run that module's setup.sh, e.g. make duti" "status-<module>" "Every change make status found in that module"
	@echo "  Modules: $(strip $(MODULES))"

all: $(MODULES) ## Run every module's setup.sh in install order (bootstrap.sh does this)

status: ## What each setup.sh would change (read-only)
	@scripts/status.sh $(DRY_RUN_MODULES) || true

profile: ## Show this laptop's profile, or switch it with NAME=<name>
	@. scripts/functions.sh && load_profile "$(NAME)" && info "Using the $$PROFILE profile."

shortcuts: ## Regenerate the shortcuts/ cheat sheets
	@shortcuts/generate.sh

$(MODULES):
	@./modules/$@/setup.sh

$(addprefix status-,$(DRY_RUN_MODULES)): status-%:
	@scripts/status.sh -v $* || true
