#! /usr/bin/env sh

. ../scripts/functions.sh

info "Setting up symlinks to useful bin files for current user"

substep_info "Declaring variables"
SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)/.local/bin"
substep_success "Variables declared"

substep_info "Creating destination folder for current user at $DESTINATION"
mkdir -p "$DESTINATION"
substep_success "Destination folder created"

substep_info "Creating symlinks..."
find * -not -name "$(basename ${0})" -type f -depth 0 | while read fn; do
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done
substep_success "Symlinks created"
clear_broken_symlinks "$DESTINATION"

success "Finished"
