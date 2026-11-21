#!/usr/bin/env bash

DIR=$(dirname "$0")
cd "$DIR"

. ../../scripts/functions.sh

profile_guard

SOURCE="$(pwd -P)"
DESTINATION="$HOME"

info "Setting up Tmux..."

find . -name ".tmux*" | while read fn; do
    fn=$(basename $fn)
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done

# tpm is cloned rather than installed through brew or MacPorts, so both machines use the same path
TPM="$HOME/.tmux/plugins/tpm"
if [ -d "$TPM" ]; then
    :
elif dry_run; then
    would "clone tpm to $TPM"
else
    substep_info "Cloning tpm to $TPM"
    if git clone https://github.com/tmux-plugins/tpm "$TPM"; then
        substep_success "Cloned tpm. Install the plugins with prefix + I inside tmux."
    else
        substep_error "Cloning tpm failed."
    fi
fi

# macOS's own terminfo has no tmux-256color, so anything using the system ncurses redraws wrongly inside tmux.
# Compile the entry from brew's or MacPorts' ncurses into ~/.terminfo with the system tic: a newer tic writes a format the system ncurses can't read.
if /usr/bin/infocmp tmux-256color >/dev/null 2>&1; then
    :
elif dry_run; then
    would "compile tmux-256color terminfo into ~/.terminfo"
else
    INFOCMP="$(command -v brew >/dev/null && echo "$(brew --prefix ncurses 2>/dev/null)/bin/infocmp")"
    [ -x "$INFOCMP" ] || INFOCMP="$(command -v infocmp)"
    make_dir "$HOME/.terminfo"
    TERMINFO_SOURCE="$(mktemp)"
    if "$INFOCMP" -x tmux-256color > "$TERMINFO_SOURCE" 2>/dev/null && /usr/bin/tic -x -o "$HOME/.terminfo" "$TERMINFO_SOURCE" 2>/dev/null; then
        substep_success "Compiled tmux-256color terminfo into ~/.terminfo"
    else
        substep_error "Could not compile tmux-256color terminfo. Install ncurses (see modules/packages/)."
    fi
    rm -f "$TERMINFO_SOURCE"
fi

success "Finished setting up Tmux."
