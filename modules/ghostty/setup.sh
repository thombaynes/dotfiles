#!/usr/bin/env bash

DIR=$(dirname "$0")
cd "$DIR"

. ../../scripts/functions.sh

profile_guard

[ -d "/Applications/Ghostty.app" ] || { info "Ghostty is not installed, skipping."; exit 0; }

SOURCE="$(pwd -P)"
DESTINATION="$HOME/Library/Application Support/com.mitchellh.ghostty"

info "Setting up Ghostty..."

make_dir "$DESTINATION"
symlink "$SOURCE/config.ghostty" "$DESTINATION/config.ghostty"

success "Finished setting up Ghostty."
