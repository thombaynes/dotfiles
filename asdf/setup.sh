#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

COMMENT=\#*

sudo -v

info "Installing asdf into user directory..."
git clone https://github.com/asdf-vm/asdf.git ~/.asdf
cd ~/.asdf
substep_info "Checking out latest branch of asdf..."
git checkout "$(git describe --abbrev=0 --tags)"
substep_info "Moving completions into asdf and fish..."
mkdir -p ~/.config/fish/completions;
cp ~/.asdf/completions/asdf.fish ~/.config/fish/completions
success "Finished installing Brewfile packages."
