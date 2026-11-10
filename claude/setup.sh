#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)/.claude"
SETTINGS="$DESTINATION/settings.json"

info "Setting up Claude Code..."

mkdir -p "$DESTINATION"
symlink "$SOURCE/statusline.sh" "$DESTINATION/statusline.sh"

# settings.json is owned by Claude Code, so merge the status line in rather than symlinking over it
[ -f "$SETTINGS" ] || echo '{}' > "$SETTINGS"
if jq '.statusLine = {type: "command", command: "~/.claude/statusline.sh"}' "$SETTINGS" > "$SETTINGS.tmp"; then
    mv "$SETTINGS.tmp" "$SETTINGS"
    substep_success "Set statusLine in $SETTINGS."
else
    rm -f "$SETTINGS.tmp"
    substep_error "Failed to update $SETTINGS."
fi

success "Finished setting up Claude Code."
