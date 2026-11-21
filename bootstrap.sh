#!/usr/bin/env bash

DIR=$(dirname "$0")
cd "$DIR"

. scripts/functions.sh

# Ask for this machine's profile (personal/auros, see profiles/) up front, before the long installs. Every setup.sh reads it
load_profile "$1"

info "Prompting for sudo password..."
if sudo -v; then
    # Keep-alive: update existing `sudo` time stamp until `setup.sh` has finished
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
    success "Sudo credentials updated."
else
    error "Failed to obtain sudo credentials."
fi

info "Installing XCode command line tools..."
if xcode-select --print-path &>/dev/null; then
    success "XCode command line tools already installed."
elif xcode-select --install &>/dev/null; then
    # The installer is a GUI that runs after this command returns, and later steps need git and a compiler
    success "Started installing XCode command line tools. Run bootstrap.sh again once the installer has finished."
    exit 0
else
    error "Failed to install XCode command line tools."
fi

# Every module's setup.sh, in the install order kept in the Makefile
make all

success "Finished installing Dotfiles"
