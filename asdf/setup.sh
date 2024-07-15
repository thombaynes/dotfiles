#! /bin/zsh

DIR=$(realpath)
. ../scripts/functions.sh

info "Installing asdf into user directory..."

substep_info "Cloning and/or checking out latest branch of asdf..."
git clone https://github.com/asdf-vm/asdf.git ~/.asdf
cd ~/.asdf || exit
git checkout "$(git describe --abbrev=0 --tags)"
substep_success "Done cloning/updating asdf"

substep_info "Moving asdf completions fish..."
mkdir -p ~/.config/fish/completions;
cp ~/.asdf/completions/asdf.fish ~/.config/fish/completions
substep_success "Done installing/updating asdf"

# substep_info "TODO Install asdf plugins based on local .tool-versions file"
# cd "$DIR" || exit;
# while IFS= read -r line; do
#   echo $line
#   echo "asdf install $line"
#   asdf install $line
# done < .tool-versions

substep_info "Moving global .tool-versions file into user directory..."
cp .tool-versions ~/.tool-versions

success "Finished installing asdf and global plugins."
