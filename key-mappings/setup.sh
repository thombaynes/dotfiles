#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)/Library/LaunchAgents"
PLIST="com.local.KeyRemapping.plist"

info "Setting up key mappings..."

mkdir -p "$DESTINATION"
symlink "$SOURCE/$PLIST" "$DESTINATION/$PLIST"

# Reload so the mapping applies now rather than at next login. bootout fails harmlessly if it isn't loaded yet.
launchctl bootout "gui/$(id -u)" "$DESTINATION/$PLIST" 2>/dev/null
if launchctl bootstrap "gui/$(id -u)" "$DESTINATION/$PLIST"; then
    substep_success "Loaded $PLIST."
else
    substep_error "Failed to load $PLIST."
fi

success "Finished setting up key mappings."
