#!/usr/bin/env bash

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
    if ! [[ $color =~ '^[0-9]$' ]] ; then
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
