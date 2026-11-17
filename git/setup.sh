#!/usr/bin/env bash

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(pwd -P)"
DESTINATION="$HOME"

info "Configuraing git..."

find . -name ".git*" | while read fn; do
    fn=$(basename $fn)
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done

PROFILE="${1:-$GIT_PROFILE}"
if [ -z "$PROFILE" ] && [ -L "$DESTINATION/.gitconfig-local" ]; then
    PROFILE="$(basename "$(readlink "$DESTINATION/.gitconfig-local")" | sed 's/^\.//; s/-gitconfig$//')"
fi
if [ -z "$PROFILE" ]; then
    printf "Git profile (personal/usertesting): "
    read PROFILE
fi

if [ ! -f "$SOURCE/.$PROFILE-gitconfig" ]; then
    error "Unknown git profile '$PROFILE'. Expected personal or usertesting."
    exit 1
fi
symlink "$SOURCE/.$PROFILE-gitconfig" "$DESTINATION/.gitconfig-local"

# Local verification of SSH signatures (git log --show-signature): trust our own key for our own email
ALLOWED_SIGNERS="$HOME/.ssh/allowed_signers"
PUBKEY="$HOME/.ssh/id_ed25519.pub"
if [ -f "$PUBKEY" ]; then
    echo "$(git config user.email) $(cat "$PUBKEY")" > "$ALLOWED_SIGNERS"
    substep_success "Wrote $ALLOWED_SIGNERS. Load the key into the agent once with: ssh-add --apple-use-keychain ~/.ssh/id_ed25519"
else
    substep_error "No $PUBKEY, so commits cannot be signed. Create one with ssh-keygen -t ed25519."
fi

success "Finished configuring git."
