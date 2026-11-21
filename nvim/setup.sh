#!/usr/bin/env bash

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

profile_guard

SOURCE="$(pwd -P)"
DESTINATION="$HOME"

info "Setting up Neovim..."

make_dir "$DESTINATION/.config"
symlink "$SOURCE" "$DESTINATION/.config/nvim"

success "Finished setting up Neovim."
