# Interactive shells. PATH and environment variables are in .zprofile.
# Plugins come from brew or MacPorts (see modules/packages/) and are skipped if they aren't installed.

# Folder of this file in the repo (it is symlinked into ~), so its neighbours can be sourced
ZSH_CONFIG=${${(%):-%x}:A:h}

# Emacs-style line editing, like fish. Without this zsh picks vi mode because EDITOR contains "vi"
bindkey -e

setopt AUTO_CD            # Type a directory name to cd into it, like fish
setopt INTERACTIVE_COMMENTS # Allow `# comments` on the command line, like fish

# History is shared between open shells and keeps one copy of each command, so autosuggestions stay useful
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS HIST_IGNORE_SPACE

# Use neovim wherever I type vi
alias vi=nvim

command -v nodenv >/dev/null && eval "$(nodenv init - zsh)"
command -v rbenv >/dev/null && eval "$(rbenv init - zsh)"

# Completion: an arrow-key menu, case-insensitive, grouped under descriptions, like fish's pager
typeset -U fpath
fpath=(${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/share/zsh/site-functions} /opt/local/share/zsh/site-functions(N/) $fpath)
zmodload zsh/complist
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*' list-colors ''
bindkey -M menuselect '^[[Z' reverse-menu-complete # Shift-Tab

# Fish's Alt-E (edit the command line in $EDITOR) and Alt-S (prepend sudo). Alt-H (man page) is a zsh default
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^[e' edit-command-line
_prepend_sudo() { [[ $BUFFER == sudo\ * ]] || BUFFER="sudo $BUFFER"; CURSOR=$#BUFFER }
zle -N _prepend_sudo
bindkey '^[s' _prepend_sudo

# Alt-Left / Alt-Right move by word (and Alt-Right accepts one word of an autosuggestion).
# The second pair is what iTerm2's Option-arrow key mappings send (see modules/iterm2/)
bindkey '^[[1;3D' backward-word '^[[1;3C' forward-word
bindkey '^[^[[D' backward-word '^[^[[C' forward-word

source $ZSH_CONFIG/abbreviations.zsh

# Load a plugin installed by brew or MacPorts, e.g. share/zsh-autosuggestions/zsh-autosuggestions.zsh
_plugin() {
    local dir
    for dir in ${HOMEBREW_PREFIX:-/opt/homebrew}/share /opt/local/share; do
        test -r $dir/$1/$1.zsh && source $dir/$1/$1.zsh && return
    done
    return 1
}

command -v starship >/dev/null && eval "$(starship init zsh)"

# Grey suggestion from history as you type, like fish. Ctrl-F accepts it (so do Right arrow and End); Tab stays plain completion
if _plugin zsh-autosuggestions; then
    ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(_abbr_accept)
    bindkey '^F' autosuggest-accept
fi

# Colour commands as you type, like fish. Typed abbreviations show as valid commands (green) before they expand
if _plugin zsh-syntax-highlighting; then
    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main regexp)
    typeset -A ZSH_HIGHLIGHT_REGEXP
    abbr_pattern="^[[:space:]]*(${(j:|:)${(@k)ABBRS}}|${(j:|:)${(@k)ABBR_FUNCTIONS}})$"
    ZSH_HIGHLIGHT_REGEXP[$abbr_pattern]=fg=green
    unset abbr_pattern
fi

# Up / Down search history for what's typed so far, anywhere in the line, like fish. Must load after syntax highlighting
if _plugin zsh-history-substring-search; then
    HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
    up=history-substring-search-up down=history-substring-search-down
else
    autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
    zle -N up-line-or-beginning-search
    zle -N down-line-or-beginning-search
    up=up-line-or-beginning-search down=down-line-or-beginning-search
fi
bindkey '^[[A' $up '^[OA' $up '^P' $up
bindkey '^[[B' $down '^[OB' $down '^N' $down
unset up down
unfunction _plugin

# Machine-specific settings that don't belong in the repo (setup.sh moves an existing ~/.zshrc here)
test -r ~/.zshrc.local && source ~/.zshrc.local
