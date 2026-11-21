#!/usr/bin/env bash

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

profile_guard

info "Setting up symlinks to useful bin files for current user"

substep_info "Declaring variables"
SOURCE="$(pwd -P)"
DESTINATION="$HOME/.local/bin"
substep_success "Variables declared"

substep_info "Creating destination folder for current user at $DESTINATION"
make_dir "$DESTINATION"
substep_success "Destination folder created"

substep_info "Creating symlinks..."
find * -not -name "$(basename ${0})" -not -name CONTEXT.md -type f -depth 0 | while read fn; do
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done
substep_success "Symlinks created"
clear_broken_symlinks "$DESTINATION"

success "Finished"
