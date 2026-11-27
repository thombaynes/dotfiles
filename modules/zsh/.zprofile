# Login shells (every new terminal tab and tmux pane on macOS): PATH and environment. Interactive setup is in .zshrc.
# PATH lives here rather than .zshenv because macOS's /etc/zprofile reorders PATH after .zshenv runs.

test -x /opt/homebrew/bin/brew && eval "$(/opt/homebrew/bin/brew shellenv)"

# Keep PATH entries unique, so nested shells don't stack duplicates
typeset -U PATH path

# MacPorts (no-op if it isn't installed), then the scripts from modules/bin/
path=(/opt/local/bin(N/) /opt/local/sbin(N/) $HOME/.local/bin $path)

# Language settings
export LC_ALL=en_CA.UTF-8
export LANG=en_CA.UTF-8

# macOS ls only colours its output when this is set (fish's ls did it by default)
export CLICOLOR=1

# File listing command shared by fzf and nvim's fzf-lua (see modules/nvim/lua/plugins/fzf.lua). ripgrep makes it MUCH FASTER
export FZF_DEFAULT_COMMAND="rg --files --hidden -G .git"

# Programs that open an editor (git, Claude Code's Ctrl-G, zsh's Alt-E) use these
export EDITOR=nvim
export VISUAL=nvim

# Cloudflare WARP re-signs TLS traffic with its own CA. Node ignores the macOS keychain, so trust that CA explicitly
# (e.g. openapi-generator-cli downloading its jar from Maven Central). No-op on machines without WARP
test -r "/Library/Application Support/Cloudflare/installed_cert.pem" && export NODE_EXTRA_CA_CERTS="/Library/Application Support/Cloudflare/installed_cert.pem"

# openjdk@21 from Homebrew is keg-only, so macOS's /usr/bin/java stub can't find it. openapi-generator-cli (node openapitools
# that generate clients) needs a real java. Avoids the sudo symlink into /Library/Java/JavaVirtualMachines. No-op without it
if [[ -d ${HOMEBREW_PREFIX:-/opt/homebrew}/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home ]]; then
    export JAVA_HOME=${HOMEBREW_PREFIX:-/opt/homebrew}/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home
    path=($JAVA_HOME/bin $path)
fi

# This machine's profile (see profiles/, linked by the setup scripts): HOME_REPO and SSH_KEY for interactive use
if [[ -r ~/.config/dotfiles/profile.sh ]]; then
    source ~/.config/dotfiles/profile.sh
    export HOME_REPO SSH_KEY
fi

# Machine-specific settings that don't belong in the repo (setup.sh moves an existing ~/.zprofile here)
test -r ~/.zprofile.local && source ~/.zprofile.local
