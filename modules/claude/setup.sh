#!/usr/bin/env bash

DIR=$(dirname "$0")
cd "$DIR"

. ../../scripts/functions.sh

profile_guard

SOURCE="$(pwd -P)"
DESTINATION="$HOME/.claude"
SETTINGS="$DESTINATION/settings.json"

info "Setting up Claude Code..."

make_dir "$DESTINATION"
symlink "$SOURCE/statusline.sh" "$DESTINATION/statusline.sh"

# Each skill in skills/ is linked whole into ~/.claude/skills
make_dir "$DESTINATION/skills"
for skill in "$SOURCE"/skills/*/; do
    symlink "${skill%/}" "$DESTINATION/skills/$(basename "$skill")"
done

# settings.json is changed by Claude Code with every model change, so we merge this subset into it rather than
# symlinking over it. Objects merge key by key and arrays are unioned, so anything else in the file is kept.
# - CLAUDE_CODE_SHELL: Claude's Bash tool and the ! prompt shell use zsh, the login shell (see modules/zsh/), so they get the same PATH and setup
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
# Merge into a temp file and only write when that changes something. A missing settings.json merges as an empty one.
CURRENT="$(cat "$SETTINGS" 2>/dev/null || echo '{}')"
MERGED="$(mktemp)"
if ! jq --argjson managed "$MANAGED_SETTINGS" '
    def merge($new):
        if type == "object" and ($new | type) == "object" then
            reduce ($new | keys_unsorted[]) as $key (.; .[$key] |= merge($new[$key]))
        elif type == "array" and ($new | type) == "array" then
            . + ($new - .)
        else
            $new
        end;
    merge($managed)' \
    <<< "$CURRENT" > "$MERGED"; then
    substep_error "Failed to merge the managed settings."
elif [ -f "$SETTINGS" ] && cmp -s <(jq -S . "$SETTINGS") <(jq -S . "$MERGED"); then
    substep_success "$SETTINGS already has the managed settings."
elif dry_run; then
    would "merge the managed settings into $SETTINGS"
# Written in place rather than moved, so the file keeps its permissions
elif cat "$MERGED" > "$SETTINGS"; then
    substep_success "Merged managed settings into $SETTINGS."
else
    substep_error "Failed to update $SETTINGS."
fi
rm -f "$MERGED"

success "Finished setting up Claude Code."
