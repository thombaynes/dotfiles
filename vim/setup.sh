#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"

info "Setting up Vim..."

mkdir -p "$DESTINATION/.config"
symlink "$SOURCE/nvim" "$DESTINATION/.config/nvim"

success "Finished setting up Vim."
