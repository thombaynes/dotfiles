# Dotfiles for this laptop. See AGENTS.md.
# bootstrap.sh is still the first step on a new Mac: make needs the Command Line Tools it installs, and it ends with make all.
# Kept to GNU Make 3.81 features, the version older Macs have.

SHELL := /bin/bash

# Install order for make all. Every folder after packages needs something it installed
FOLDERS := packages     # Brewfile or Portlist, from the profile's PACKAGE_MANAGER
FOLDERS += zsh          # Login shell and zsh config. Reads the abbreviations in fish/
FOLDERS += fish         # Previous shell's config, kept working
FOLDERS += git          # Config and the SSH signing key setup
FOLDERS += tmux         # Clones tpm
FOLDERS += nvim
FOLDERS += bin
FOLDERS += claude
FOLDERS += duti         # Default apps, needs the apps installed by packages
FOLDERS += macos
FOLDERS += key-mappings
FOLDERS += hammerspoon  # Skips itself when Hammerspoon is not installed
FOLDERS += ghostty      # Likewise
FOLDERS += iterm2       # Likewise. Also copies the Nerd Font symbols that packages installed
FOLDERS += vscode       # Likewise

# What make status covers. macos has no dry run yet (see TODO/TODO.txt)
DRY_RUN_FOLDERS := $(filter-out macos,$(FOLDERS))

# Folder names are also directories, so without .PHONY make would call them up to date
.PHONY: help all status profile shortcuts $(FOLDERS) $(addprefix status-,$(DRY_RUN_FOLDERS))

# setup.sh scripts ask for sudo, so never run them in parallel
.NOTPARALLEL:

help:
	@grep -E '^[a-z-]+:.*## ' $(MAKEFILE_LIST) | awk -F':.*## ' '{printf "  %-18s %s\n", $$1, $$2}'
	@printf "  %-18s %s\n" "<folder>" "Run that folder's setup.sh, e.g. make duti" "status-<folder>" "Every change make status found in that folder"
	@echo "  Folders: $(strip $(FOLDERS))"

all: $(FOLDERS) ## Run every setup.sh in install order (bootstrap.sh does this)

status: ## What each setup.sh would change (read-only)
	@scripts/status.sh $(DRY_RUN_FOLDERS) || true

profile: ## Show this laptop's profile, or switch it with NAME=<name>
	@. scripts/functions.sh && load_profile "$(NAME)" && info "Using the $$PROFILE profile."

shortcuts: ## Regenerate the shortcuts/ cheat sheets
	@shortcuts/generate.sh

$(FOLDERS):
	@./$@/setup.sh

$(addprefix status-,$(DRY_RUN_FOLDERS)): status-%:
	@scripts/status.sh -v $* || true
