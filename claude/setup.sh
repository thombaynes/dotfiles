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

# settings.json is owned by Claude Code, so merge the status line and shell in rather than symlinking over it.
# Claude's Bash tool only supports bash or zsh (not fish), so point it at Homebrew's bash (see packages/Brewfile).
[ -f "$SETTINGS" ] || echo '{}' > "$SETTINGS"
if jq --arg shell "$(brew --prefix)/bin/bash" \
    '.statusLine = {type: "command", command: "~/.claude/statusline.sh"} | .env.CLAUDE_CODE_SHELL = $shell' \
    "$SETTINGS" > "$SETTINGS.tmp"; then
    mv "$SETTINGS.tmp" "$SETTINGS"
    substep_success "Set statusLine and CLAUDE_CODE_SHELL in $SETTINGS."
else
    rm -f "$SETTINGS.tmp"
    substep_error "Failed to update $SETTINGS."
fi

success "Finished setting up Claude Code."
