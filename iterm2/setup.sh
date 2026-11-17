#!/usr/bin/env bash

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

# Get iterm2 to look here for its config
DIR_ABS="$(pwd -P)"
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$DIR_ABS"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

# MacPorts installs fonts to /opt/local/share/fonts, which macOS does not scan, and it ignores symlinked
# fonts, so copy the Nerd Font symbols (icons for neo-tree etc.) into ~/Library/Fonts. Then pick "Symbols Nerd Font Mono"
# as the non-ASCII font in iTerm2 > Settings > Profiles > Text.
FONT_DIR="/opt/local/share/fonts"
if [ -d "$FONT_DIR" ]; then
    mkdir -p "$HOME/Library/Fonts"
    find "$FONT_DIR" -iname 'SymbolsNerdFont*.ttf' | while read -r font; do
        rm -f "$HOME/Library/Fonts/$(basename "$font")"
        if cp "$font" "$HOME/Library/Fonts/"; then
            substep_success "Copied $font to ~/Library/Fonts."
        else
            substep_error "Copying $font failed."
        fi
    done
fi
