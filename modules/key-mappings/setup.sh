#!/usr/bin/env bash

DIR=$(dirname "$0")
cd "$DIR"

. ../../scripts/functions.sh

profile_guard

SOURCE="$(pwd -P)"
DESTINATION="$HOME/Library/LaunchAgents"
PLIST="com.local.KeyRemapping.plist"

info "Setting up key mappings..."

make_dir "$DESTINATION"
symlink "$SOURCE/$PLIST" "$DESTINATION/$PLIST"

if dry_run; then
    # The plist's Label is its file name
    launchctl print "gui/$(id -u)/${PLIST%.plist}" >/dev/null 2>&1 || would "load $PLIST"
else
    # Reload so the mapping applies now rather than at next login. bootout fails harmlessly if it isn't loaded yet.
    launchctl bootout "gui/$(id -u)" "$DESTINATION/$PLIST" 2>/dev/null
    if launchctl bootstrap "gui/$(id -u)" "$DESTINATION/$PLIST"; then
        substep_success "Loaded $PLIST."
    else
        substep_error "Failed to load $PLIST."
    fi
fi

success "Finished setting up key mappings."
