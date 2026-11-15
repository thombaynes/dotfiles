#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(pwd -P)"
DESTINATION="$HOME/.gnupg"
CONF="$DESTINATION/gpg-agent.conf"

# MacPorts installs to /opt/local, which is often not on PATH in a non-login shell
PATH="$PATH:/opt/local/bin"

info "Setting up gpg-agent..."

mkdir -p "$DESTINATION"
chmod 700 "$DESTINATION"

# Generated rather than symlinked because the pinentry-mac path differs between brew and MacPorts
cp "$SOURCE/gpg-agent.conf" "$CONF"
# MacPorts installs it as an app bundle rather than putting it on the PATH
MACPORTS_PINENTRY="/Applications/MacPorts/pinentry-mac.app/Contents/MacOS/pinentry-mac"
if PINENTRY="$(command -v pinentry-mac || ls "$MACPORTS_PINENTRY" 2>/dev/null)"; then
    echo "pinentry-program $PINENTRY" >> "$CONF"
    substep_success "Using $PINENTRY (tick 'Save in Keychain' in its prompt to stop being asked)."
else
    substep_info "pinentry-mac not found, so gpg will prompt in the terminal. Install it from packages/ and re-run."
fi

substep_info "Restarting gpg-agent to pick up the config..."
gpgconf --kill gpg-agent

success "Finished setting up gpg-agent."
