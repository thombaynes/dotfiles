#!/usr/bin/env bash

DIR=$(dirname "$0")
cd "$DIR"

. ../../scripts/functions.sh

profile_guard

[ -d "/Applications/Hammerspoon.app" ] || { info "Hammerspoon is not installed, skipping."; exit 0; }

SOURCE="$(pwd -P)"
DESTINATION="$HOME/.hammerspoon"

info "Setting up Hammerspoon..."

substep_info "Creating Hammerspoon folder..."
make_dir $DESTINATION

find * -name "*.lua" -o -name "*.applescript" -o -name "*.js" | while read fn; do
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done
clear_broken_symlinks "$DESTINATION"

success "Finished setting up Hammerspoon."
