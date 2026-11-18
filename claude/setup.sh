#!/usr/bin/env bash

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(pwd -P)"
DESTINATION="$HOME/.claude"
SETTINGS="$DESTINATION/settings.json"

info "Setting up Claude Code..."

mkdir -p "$DESTINATION"
symlink "$SOURCE/statusline.sh" "$DESTINATION/statusline.sh"

# settings.json is changed by Claude Code with every model change, so we merge to it rather than symlinking over it.
# Claude's Bash tool and the ! prompt shell use zsh, the login shell (see zsh/), so they get the same PATH and setup
ZSH_PATH=/bin/zsh
[ -f "$SETTINGS" ] || echo '{}' > "$SETTINGS"
if jq --arg shell "$ZSH_PATH" \
    '.statusLine = {type: "command", command: "~/.claude/statusline.sh"} | .env.CLAUDE_CODE_SHELL = $shell' \
    "$SETTINGS" > "$SETTINGS.tmp"; then
    mv "$SETTINGS.tmp" "$SETTINGS"
    substep_success "Updated $SETTINGS (CLAUDE_CODE_SHELL: $ZSH_PATH)."
else
    rm -f "$SETTINGS.tmp"
    substep_error "Failed to update $SETTINGS."
fi

success "Finished setting up Claude Code."
