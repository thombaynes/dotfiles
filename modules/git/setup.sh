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
# The whole file is rewritten from the template below, so don't add anything to it by hand: put it in the profile's identity file instead.
# Remove the link older setups made, so writing it doesn't go through into the repo.
LOCAL="$DESTINATION/.gitconfig-local"
PUBKEY="$SSH_KEY.pub"
LOCAL_CONFIG=$(cat <<EOF
[include]
	path = $IDENTITY
[user]
	signingkey = $PUBKEY
EOF
)
if [ ! -h "$LOCAL" ] && [ "$(cat "$LOCAL" 2>/dev/null)" = "$LOCAL_CONFIG" ]; then
    :
elif dry_run; then
    would "write $LOCAL (identity: $IDENTITY, signing key: $PUBKEY)"
else
    [ -h "$LOCAL" ] && rm "$LOCAL"
    if echo "$LOCAL_CONFIG" > "$LOCAL"; then
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
