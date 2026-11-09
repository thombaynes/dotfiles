#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)/Library/Application Support/com.mitchellh.ghostty"

info "Setting up Ghostty..."

mkdir -p "$DESTINATION"
symlink "$SOURCE/config.ghostty" "$DESTINATION/config.ghostty"

success "Finished setting up Ghostty."
