#!/usr/bin/env bash

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(pwd -P)"
DESTINATION="$HOME"

info "Setting up Neovim..."

mkdir -p "$DESTINATION/.config"
symlink "$SOURCE" "$DESTINATION/.config/nvim"

success "Finished setting up Neovim."
