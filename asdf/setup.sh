#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

COMMENT=\#*

sudo -v

info "Installing asdf into user directory..."

substep_info "Cloning and/or checking out latest branch of asdf..."
git clone https://github.com/asdf-vm/asdf.git ~/.asdf
cd ~/.asdf
git checkout "$(git describe --abbrev=0 --tags)"

substep_info "Moving completions into asdf and fish..."
mkdir -p ~/.config/fish/completions;
cp ~/.asdf/completions/asdf.fish ~/.config/fish/completions

substep_info "TODO Install asdf plugins based on local .tool-versions file - opted against this because it takes so long for erlang stuff"
#cd "$DIR"
#asdf install

substep_info "Moving global .tool-versions file into user directory..."
cp ./.tool-versions ~/.tool-versions

success "Finished installing asdf and global plugins."
