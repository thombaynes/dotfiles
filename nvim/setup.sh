#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"

info "Setting up Neovim..."

mkdir -p "$DESTINATION/.config"
symlink "$SOURCE" "$DESTINATION/.config/nvim"

success "Finished setting up Neovim."
