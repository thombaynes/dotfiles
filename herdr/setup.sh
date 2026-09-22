#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)/.config/herdr"

info "Setting up Herdr..."

# Herdr reads a single config.toml out of ~/.config/herdr, so the directory has
# to exist before we can symlink into it.
if mkdir -p "$DESTINATION"; then
    substep_success "Ensured $DESTINATION exists."
else
    substep_error "Failed to create $DESTINATION."
fi

symlink "$SOURCE/config.toml" "$DESTINATION/config.toml"

# Pick up the new config without making the user detach and relaunch.
if command -v herdr > /dev/null 2>&1; then
    if herdr server reload-config > /dev/null 2>&1; then
        substep_success "Reloaded config in the running Herdr server."
    else
        substep_info "No running Herdr server to reload."
    fi
else
    substep_info "Herdr is not installed yet; config will apply on first launch."
fi

success "Finished setting up Herdr."
