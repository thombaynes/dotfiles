#!/usr/bin/env bash

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

[ -d "/Applications/Ghostty.app" ] || { info "Ghostty is not installed, skipping."; exit 0; }

SOURCE="$(pwd -P)"
DESTINATION="$HOME/Library/Application Support/com.mitchellh.ghostty"

info "Setting up Ghostty..."

mkdir -p "$DESTINATION"
symlink "$SOURCE/config.ghostty" "$DESTINATION/config.ghostty"

success "Finished setting up Ghostty."
