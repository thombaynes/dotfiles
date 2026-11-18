#!/usr/bin/env bash

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(pwd -P)"
# macOS ships zsh and already lists it in /etc/shells, so use it rather than a brew or MacPorts copy
ZSH_PATH=/bin/zsh

info "Setting up zsh..."

for file in .zprofile .zshrc; do
    # An existing file is machine-specific (work tools and the like): keep it as the .local file the repo's copy sources
    if [ -f "$HOME/$file" ] && [ ! -h "$HOME/$file" ] && [ ! -e "$HOME/$file.local" ]; then
        mv "$HOME/$file" "$HOME/$file.local" && substep_success "Moved existing ~/$file to ~/$file.local"
    fi
    symlink "$SOURCE/$file" "$HOME/$file"
done

# The starship prompt reads its config from ~/.config
mkdir -p "$HOME/.config"
symlink "$SOURCE/starship.toml" "$HOME/.config/starship.toml"

set_zsh_shell() {
    # $SHELL is only updated at the next login, so ask Directory Services for the current login shell
    if [ "$(dscl . -read "/Users/$USER" UserShell | awk '{ print $2 }')" = "$ZSH_PATH" ]; then
        substep_success "zsh is already the login shell."
    else
        substep_info "Changing shell to zsh"
        if sudo chsh -s "$ZSH_PATH" "$USER"; then
            substep_success "Changed shell to zsh. Open a new terminal to use it."
        else
            substep_error "Failed changing shell to zsh"
            return 1
        fi
    fi
}

if set_zsh_shell; then
    success "Successfully set up zsh."
else
    error "Failed setting up zsh."
fi
