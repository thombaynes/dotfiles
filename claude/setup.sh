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

# settings.json is changed by Claude Code with every model change, so we merge this subset into it rather than
# symlinking over it. Objects merge key by key and arrays are unioned, so anything else in the file is kept.
# - CLAUDE_CODE_SHELL: Claude's Bash tool and the ! prompt shell use zsh, the login shell (see zsh/), so they get the same PATH and setup
# - deny Artifact: no claude.ai hosted pages, so Claude answers in the terminal instead of publishing
MANAGED_SETTINGS=$(cat <<'EOF'
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh"
  },
  "env": {
    "CLAUDE_CODE_SHELL": "/bin/zsh"
  },
  "permissions": {
    "deny": ["Artifact"]
  }
}
EOF
)
[ -f "$SETTINGS" ] || echo '{}' > "$SETTINGS"
if jq --argjson managed "$MANAGED_SETTINGS" '
    def merge($new):
        if type == "object" and ($new | type) == "object" then
            reduce ($new | keys_unsorted[]) as $key (.; .[$key] |= merge($new[$key]))
        elif type == "array" and ($new | type) == "array" then
            . + ($new - .)
        else
            $new
        end;
    merge($managed)' \
    "$SETTINGS" > "$SETTINGS.tmp"; then
    mv "$SETTINGS.tmp" "$SETTINGS"
    substep_success "Merged managed settings into $SETTINGS."
else
    rm -f "$SETTINGS.tmp"
    substep_error "Failed to update $SETTINGS."
fi

success "Finished setting up Claude Code."
