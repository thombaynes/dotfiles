#!/usr/bin/env bash

DIR=$(dirname "$0")
cd "$DIR"

. ../../scripts/functions.sh

profile_guard

[ -d "/Applications/Visual Studio Code.app" ] || { info "VS Code is not installed, skipping."; exit 0; }

SOURCE="$(pwd -P)"
DESTINATION="$HOME/Library/Application Support/Code/User"

info "Setting up Visual Studio Code..."

substep_info "Creating Visual Studio Code folders..."
make_dir "$DESTINATION"

find * -not -name "$(basename ${0})" -type f | while read fn; do
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done

success "Finished setting up Visual Studio Code"
