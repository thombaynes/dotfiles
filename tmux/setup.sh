#!/usr/bin/env bash

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(pwd -P)"
DESTINATION="$HOME"

info "Setting up Tmux..."

find . -name ".tmux*" | while read fn; do
    fn=$(basename $fn)
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done

# tpm is cloned rather than installed through brew or MacPorts, so both machines use the same path
TPM="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM" ]; then
    substep_info "Cloning tpm to $TPM"
    if git clone https://github.com/tmux-plugins/tpm "$TPM"; then
        substep_success "Cloned tpm. Install the plugins with prefix + I inside tmux."
    else
        substep_error "Cloning tpm failed."
    fi
fi

success "Finished setting up Tmux."
