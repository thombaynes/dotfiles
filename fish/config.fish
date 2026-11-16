#!/usr/local/bin/fish
test -x /opt/homebrew/bin/brew; and eval "$(/opt/homebrew/bin/brew shellenv)"

# MacPorts (no-op if it isn't installed)
fish_add_path /opt/local/bin /opt/local/sbin

# Allows more than 64 bit colour
set -x -g TERM "tmux-256color"

# Include the following in the $PATH
set -g fish_user_paths "$HOME/.local/bin" $fish_user_paths

status --is-interactive; and . (nodenv init -|psub)
status --is-interactive; and rbenv init - fish | source

# Language settings
set -x -g LC_ALL en_CA.UTF-8
set -x -g LANG en_CA.UTF-8

# File listing command shared by fzf and nvim's fzf-lua (see nvim/lua/plugins/fzf.lua). ripgrep makes it MUCH FASTER
set -x -g FZF_DEFAULT_COMMAND "rg --files --hidden --glob '!.git'"

# Keep tmuxinator project files in the foundry workspace so they are easy to edit alongside the repos
set -x -g TMUXINATOR_CONFIG ~/foundry/tmuxinator

# Use neovim wherever I type vi
alias vi nvim

# Programs that open an editor (git, Claude Code's Ctrl-G, fish's Alt-E) use these
set -x -g EDITOR nvim
set -x -g VISUAL nvim

# gpg's pinentry needs to know which terminal to prompt on, otherwise signing commits fails with "Inappropriate ioctl for device"
status --is-interactive; and set -x -g GPG_TTY (tty)

# https://stackoverflow.com/questions/26208231/modifying-path-with-fish-shell The top answer says to use a command, but after fish 3.X we can put PATH stuff here and it will not add it repeatedly
# set fish_user_paths ./bin $fish_user_paths
setup
