#!/usr/bin/env bash

DIR=$(dirname "$0")
cd "$DIR"

. ../../scripts/functions.sh

# Pass a profile name to switch to it before the guard reads it
load_profile "$1"
profile_guard

SOURCE="$(pwd -P)"
DESTINATION="$HOME"

info "Configuring git..."

find . -name ".git*" | while read fn; do
    fn=$(basename $fn)
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done

IDENTITY="$SOURCE/.$PROFILE-gitconfig"
if [ ! -f "$IDENTITY" ]; then
    error "No $IDENTITY for profile '$PROFILE'."
    exit 1
fi

# ~/.gitconfig-local is generated rather than linked, as it combines the profile's identity file with its signing key.
# Remove the link older setups made, so git config doesn't write through it into the repo.
LOCAL="$DESTINATION/.gitconfig-local"
PUBKEY="$SSH_KEY.pub"
if [ ! -h "$LOCAL" ] && [ "$(git config --file "$LOCAL" include.path 2>/dev/null)" = "$IDENTITY" ] && [ "$(git config --file "$LOCAL" user.signingkey 2>/dev/null)" = "$PUBKEY" ]; then
    :
elif dry_run; then
    would "write $LOCAL (identity: $IDENTITY, signing key: $PUBKEY)"
else
    [ -h "$LOCAL" ] && rm "$LOCAL"
    if git config --file "$LOCAL" include.path "$IDENTITY" && git config --file "$LOCAL" user.signingkey "$PUBKEY"; then
        substep_success "Wrote $LOCAL (identity: $IDENTITY, signing key: $PUBKEY)."
    else
        substep_error "Failed to write $LOCAL."
    fi
fi

# Local verification of SSH signatures (git log --show-signature): trust our own key for our own email.
# The email is read from the identity file, as ~/.gitconfig-local may not include it yet in a dry run.
ALLOWED_SIGNERS="$HOME/.ssh/allowed_signers"
if [ -f "$PUBKEY" ]; then
    SIGNER="$(git config --file "$IDENTITY" user.email) $(cat "$PUBKEY")"
    if [ "$(cat "$ALLOWED_SIGNERS" 2>/dev/null)" = "$SIGNER" ]; then
        :
    elif dry_run; then
        would "write $ALLOWED_SIGNERS"
    else
        echo "$SIGNER" > "$ALLOWED_SIGNERS"
        substep_success "Wrote $ALLOWED_SIGNERS. Load the key into the agent once with: ssh-add --apple-use-keychain $SSH_KEY"
    fi
else
    substep_error "No $PUBKEY, so commits cannot be signed. Create one with ssh-keygen -t ed25519 -f $SSH_KEY."
fi

success "Finished configuring git."
