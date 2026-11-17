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

# settings.json is owned by Claude Code, so merge the status line and shell in rather than symlinking over it.
# Claude's Bash tool only supports bash or zsh (not fish), so point it at the modern bash that brew or MacPorts
# installed (see packages/), not macOS's /bin/bash 3.2. MacPorts' bin is often not on PATH in a non-login shell.
BASH_PATH="$(PATH="$PATH:/opt/local/bin" type -ap bash | grep -vx /bin/bash | head -1)"
SHELL_FILTER="."
if [ -n "$BASH_PATH" ]; then
    SHELL_FILTER='.env.CLAUDE_CODE_SHELL = $shell'
else
    substep_error "No bash other than /bin/bash found, so CLAUDE_CODE_SHELL is left as is. Run packages/setup.sh first."
fi
[ -f "$SETTINGS" ] || echo '{}' > "$SETTINGS"
if jq --arg shell "$BASH_PATH" \
    ".statusLine = {type: \"command\", command: \"~/.claude/statusline.sh\"} | $SHELL_FILTER" \
    "$SETTINGS" > "$SETTINGS.tmp"; then
    mv "$SETTINGS.tmp" "$SETTINGS"
    substep_success "Updated $SETTINGS (CLAUDE_CODE_SHELL: ${BASH_PATH:-unchanged})."
else
    rm -f "$SETTINGS.tmp"
    substep_error "Failed to update $SETTINGS."
fi

success "Finished setting up Claude Code."
