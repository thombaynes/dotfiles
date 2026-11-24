#!/usr/bin/env bash

DIR=$(dirname "$0")
cd "$DIR"

. ../../scripts/functions.sh

profile_guard

SOURCE="$(pwd -P)"
# zsh comes from the profile's package manager (see modules/packages), not the older copy macOS ships
if [ "$PACKAGE_MANAGER" = brew ]; then
    ZSH_PATH="$(brew --prefix 2>/dev/null || echo /opt/homebrew)/bin/zsh"
else
    ZSH_PATH=/opt/local/bin/zsh
fi

info "Setting up zsh..."

for file in .zprofile .zshrc; do
    # An existing file is machine-specific (work tools and the like): keep it as the .local file the repo's copy sources
    if [ -f "$HOME/$file" ] && [ ! -h "$HOME/$file" ] && [ ! -e "$HOME/$file.local" ]; then
        if dry_run; then
            would "move existing ~/$file to ~/$file.local"
        else
            mv "$HOME/$file" "$HOME/$file.local" && substep_success "Moved existing ~/$file to ~/$file.local"
        fi
    fi
    symlink "$SOURCE/$file" "$HOME/$file"
done

# The starship prompt reads its config from ~/.config
make_dir "$HOME/.config"
symlink "$SOURCE/starship.toml" "$HOME/.config/starship.toml"

set_zsh_shell() {
    if [ ! -x "$ZSH_PATH" ]; then
        # The packages module installs it, so on a dry run before that this is a change to report
        if dry_run; then
            would "install zsh with $PACKAGE_MANAGER (expected at $ZSH_PATH) and make it the login shell"
            return
        fi
        substep_error "$ZSH_PATH is not installed. Run make packages first."
        return 1
    fi
    # chsh only accepts shells listed in /etc/shells
    if ! grep -qx "$ZSH_PATH" /etc/shells; then
        if dry_run; then
            would "add $ZSH_PATH to /etc/shells"
        else
            substep_info "Adding $ZSH_PATH to /etc/shells"
            echo "$ZSH_PATH" | sudo tee -a /etc/shells > /dev/null || return 1
        fi
    fi
    # $SHELL is only updated at the next login, so ask Directory Services for the current login shell
    if [ "$(dscl . -read "/Users/$USER" UserShell | awk '{ print $2 }')" = "$ZSH_PATH" ]; then
        substep_success "zsh is already the login shell."
    elif dry_run; then
        would "change the login shell to $ZSH_PATH"
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
