#!/usr/bin/env bash

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(pwd -P)"
DESTINATION="$HOME/.config/fish"

info "Setting up fish shell..."

substep_info "Creating fish config folders..."
mkdir -p "$DESTINATION/functions"
mkdir -p "$DESTINATION/conf.d"

find * -name "*.fish" | while read fn; do
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done
clear_broken_symlinks "$DESTINATION"

success "Successfully set up fish config. zsh is the login shell (see zsh/setup.sh)."
