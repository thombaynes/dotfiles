#!/usr/bin/env bash

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

profile_guard

[ -d "/Applications/iTerm.app" ] || { info "iTerm2 is not installed, skipping."; exit 0; }

# Get iterm2 to look here for its config
DIR_ABS="$(pwd -P)"
# defaults read prints a bool as 1 or 0
if [ "$(defaults read com.googlecode.iterm2 PrefsCustomFolder 2>/dev/null)" = "$DIR_ABS" ] && [ "$(defaults read com.googlecode.iterm2 LoadPrefsFromCustomFolder 2>/dev/null)" = 1 ]; then
    :
elif dry_run; then
    would "point iTerm2 at $DIR_ABS for its preferences"
else
    defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$DIR_ABS"
    defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
fi

# MacPorts installs fonts to /opt/local/share/fonts, which macOS does not scan, and it ignores symlinked
# fonts, so copy the Nerd Font symbols (icons for neo-tree etc.) into ~/Library/Fonts. Then pick "Symbols Nerd Font Mono"
# as the non-ASCII font in iTerm2 > Settings > Profiles > Text.
FONT_DIR="/opt/local/share/fonts"
if [ -d "$FONT_DIR" ]; then
    make_dir "$HOME/Library/Fonts"
    find "$FONT_DIR" -iname 'SymbolsNerdFont*.ttf' | while read -r font; do
        COPY="$HOME/Library/Fonts/$(basename "$font")"
        if cmp -s "$font" "$COPY"; then
            continue
        elif dry_run; then
            would "copy $font to ~/Library/Fonts"
            continue
        fi
        rm -f "$COPY"
        if cp "$font" "$HOME/Library/Fonts/"; then
            substep_success "Copied $font to ~/Library/Fonts."
        else
            substep_error "Copying $font failed."
        fi
    done
fi
