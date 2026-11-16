#! /usr/bin/env sh

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

success "Finished configuring git."
