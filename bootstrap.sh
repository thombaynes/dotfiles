#!/usr/bin/env bash

DIR=$(dirname "$0")
cd "$DIR"

. scripts/functions.sh

info "Prompting for sudo password..."
if sudo -v; then
    # Keep-alive: update existing `sudo` time stamp until `setup.sh` has finished
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
    success "Sudo credentials updated."
else
    error "Failed to obtain sudo credentials."
fi

info "Installing XCode command line tools..."
if xcode-select --print-path &>/dev/null; then
    success "XCode command line tools already installed."
elif xcode-select --install &>/dev/null; then
    # The installer is a GUI that runs after this command returns, and later steps need git and a compiler
    success "Started installing XCode command line tools. Run bootstrap.sh again once the installer has finished."
    exit 0
else
    error "Failed to install XCode command line tools."
fi

# Package control must be executed first in order for the rest to work
./packages/setup.sh

# Explicit order, so dependencies are visible. Run after packages: every one of these needs something it installed.
SETUPS=(
    fish        # Login shell and fish config
    git         # Config and the SSH signing key setup
    tmux        # Clones tpm
    nvim
    bin
    claude
    duti        # Default apps, needs the apps installed by packages
    macos
    key-mappings
    hammerspoon # Skips itself when Hammerspoon is not installed
    ghostty     # Likewise
    iterm2      # Likewise. Also copies the Nerd Font symbols that packages installed
    vscode      # Likewise
)
for folder in "${SETUPS[@]}"; do
    ./$folder/setup.sh
done

success "Finished installing Dotfiles"
