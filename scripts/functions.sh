#!/usr/bin/env bash

PROFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../profiles" && pwd -P)"
# Outside the repo, so each laptop keeps its own choice and a pull never changes it
PROFILE_LINK="$HOME/.config/dotfiles/profile.sh"

# Loads this machine's profile (see profiles/) into the calling script's variables.
# Asks which profile on first run. Pass a profile name to switch to it.
load_profile() {
    if [ -n "$1" ] || [ ! -e "$PROFILE_LINK" ]; then
        local name="$1" names
        names="$(for f in "$PROFILES_DIR"/*.sh; do basename "$f" .sh; done | paste -sd/ -)"
        if [ -z "$name" ]; then
            printf "Profile for this machine (%s): " "$names"
            read name
        fi
        if [ ! -f "$PROFILES_DIR/$name.sh" ]; then
            error "Unknown profile '$name'. Expected $names."
            exit 1
        fi
        mkdir -p "$(dirname "$PROFILE_LINK")"
        symlink "$PROFILES_DIR/$name.sh" "$PROFILE_LINK"
    fi
    . "$PROFILE_LINK"
}

symlink() {
    OVERWRITTEN=""
    if [ -h "$2" ]; then
        # An old link: nothing to lose, just replace it
        OVERWRITTEN="(Replaced old link)"
        if ! rm "$2"; then
            substep_error "Failed to remove existing link at $2."
        fi
    elif [ -e "$2" ]; then
        # A real file or directory: move it aside rather than deleting it
        BACKUP="$2.bak"
        [ -e "$BACKUP" ] && BACKUP="$2.bak.$(date +%Y%m%d%H%M%S)"
        OVERWRITTEN="(Existing moved to $BACKUP)"
        if ! mv "$2" "$BACKUP"; then
            substep_error "Failed to move existing file(s) at $2 to $BACKUP."
        fi
    fi
    if ln -s "$1" "$2"; then
        substep_success "Symlinked $2 to $1. $OVERWRITTEN"
    else
        substep_error "Symlinking $2 to $1 failed."
    fi
}

clear_broken_symlinks() {
    substep_info "Clearing broken symlinks"
    find -L "$1" -type l | while read fn; do
        if rm "$fn"; then
            substep_success "Removed broken symlink at $fn."
        else
            substep_error "Failed to remove broken symlink at $fn."
        fi
    done
}

# Took these printing functions from https://github.com/Sajjadhosn/dotfiles
coloredEcho() {
    local exp="$1";
    local color="$2";
    local arrow="$3";
    if ! [[ $color =~ ^[0-9]$ ]] ; then
       case $(echo $color | tr '[:upper:]' '[:lower:]') in
        black) color=0 ;;
        red) color=1 ;;
        green) color=2 ;;
        yellow) color=3 ;;
        blue) color=4 ;;
        magenta) color=5 ;;
        cyan) color=6 ;;
        white|*) color=7 ;; # white or invalid color
       esac
    fi
    tput bold;
    tput setaf "$color";
    echo "$arrow $exp";
    tput sgr0;
}

info() {
    coloredEcho "$1" blue "========>"
}

success() {
    coloredEcho "$1" green "========>"
}

error() {
    coloredEcho "$1" red "========>"
}

substep_info() {
    coloredEcho "$1" blue "===="
}

substep_success() {
    coloredEcho "$1" green "===="
}

substep_error() {
    coloredEcho "$1" red "===="
}
