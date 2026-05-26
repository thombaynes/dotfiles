#!/usr/local/bin/fish
eval "$(/opt/homebrew/bin/brew shellenv)"

# Allows more than 64 bit colour
set -x -g TERM "xterm-256color"

# Include the following in the $PATH
set -g fish_user_paths "/Users/tbaynes/.local/bin" $fish_user_paths

source ~/.asdf/asdf.fish
status --is-interactive; and . (nodenv init -|psub)
status --is-interactive; and rbenv init - fish | source

# Language settings
set -x -g LC_ALL en_CA.UTF-8
set -x -g LANG en_CA.UTF-8

# Set FZF default command to use ripgrep (rg) - this makes it MUCH FASTER
set -x -g FZF_DEFAULT_COMMAND rg --files --hidden

# https://stackoverflow.com/questions/26208231/modifying-path-with-fish-shell The top answer says to use a command, but after fish 3.X we can put PATH stuff here and it will not add it repeatedly
# set fish_user_paths ./bin $fish_user_paths
setup
