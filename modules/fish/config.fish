test -x /opt/homebrew/bin/brew; and eval "$(/opt/homebrew/bin/brew shellenv)"

# MacPorts (no-op if it isn't installed)
fish_add_path -g /opt/local/bin /opt/local/sbin

# Include the following in the $PATH
fish_add_path -g $HOME/.local/bin

status --is-interactive; and . (nodenv init -|psub)
status --is-interactive; and rbenv init - fish | source

# Language settings
set -x -g LC_ALL en_CA.UTF-8
set -x -g LANG en_CA.UTF-8

# File listing command shared by fzf and nvim's fzf-lua (see nvim/lua/plugins/fzf.lua). ripgrep makes it MUCH FASTER
set -x -g FZF_DEFAULT_COMMAND "rg --files --hidden --glob '!.git'"

# Use neovim wherever I type vi
alias vi nvim

# Programs that open an editor (git, Claude Code's Ctrl-G, fish's Alt-E) use these
set -x -g EDITOR nvim
set -x -g VISUAL nvim
