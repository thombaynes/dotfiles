# Login shells (every new terminal tab and tmux pane on macOS): PATH and environment. Interactive setup is in .zshrc.
# PATH lives here rather than .zshenv because macOS's /etc/zprofile reorders PATH after .zshenv runs.

test -x /opt/homebrew/bin/brew && eval "$(/opt/homebrew/bin/brew shellenv)"

# Keep PATH entries unique, so nested shells don't stack duplicates
typeset -U PATH path

# MacPorts (no-op if it isn't installed), then the scripts from bin/
path=(/opt/local/bin(N/) /opt/local/sbin(N/) $HOME/.local/bin $path)

# Language settings
export LC_ALL=en_CA.UTF-8
export LANG=en_CA.UTF-8

# File listing command shared by fzf and nvim's fzf-lua (see nvim/lua/plugins/fzf.lua). ripgrep makes it MUCH FASTER
export FZF_DEFAULT_COMMAND="rg --files --hidden --glob '!.git'"

# Programs that open an editor (git, Claude Code's Ctrl-G, zsh's Alt-E) use these
export EDITOR=nvim
export VISUAL=nvim

# Machine-specific settings that don't belong in the repo (setup.sh moves an existing ~/.zprofile here)
test -r ~/.zprofile.local && source ~/.zprofile.local
