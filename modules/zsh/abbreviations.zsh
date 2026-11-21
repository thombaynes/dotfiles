# Abbreviations, inspired by fish: `gs` then Space or Enter becomes `git status`, so history holds the full command.
# The list is abbreviations.list, which the cheat sheet reads too.
# Like fish they only expand in command position (start of the line, or after ; | & or a `(`). Ctrl-Space inserts a plain space.

typeset -gA ABBRS ABBR_FUNCTIONS

() {
    setopt localoptions extendedglob
    local line key expansion
    for line in "${(@f)$(<$1)}"; do
        [[ $line == [[:space:]]#(\#*|) ]] && continue
        line=${line%%[[:space:]]##\#*}
        key=${line%%[[:space:]]*}
        expansion=${${line#$key}##[[:space:]]#}
        if [[ $expansion == @* ]]; then
            ABBR_FUNCTIONS[$key]=${expansion#@}
        else
            ABBRS[$key]=$expansion
        fi
    done
} ${${(%):-%x}:A:h}/abbreviations.list

# The `@__abbr_grbm` abbreviation: rebase onto the local copy of the repo's default branch (from origin/HEAD)
__abbr_grbm() {
    print -r -- "git rebase ${$(git symbolic-ref --short refs/remotes/origin/HEAD)#origin/}"
}

_abbr_expand() {
    setopt localoptions extendedglob
    local word=${LBUFFER##*[[:space:]\;\|\&\(]}
    [[ -n $word ]] || return
    local before=${LBUFFER:0:$(( $#LBUFFER - $#word ))}
    [[ $before == ([[:space:]]#|*[\;\|\&\(][[:space:]]#) ]] || return
    if (( $+ABBRS[$word] )); then
        LBUFFER=$before$ABBRS[$word]
    elif (( $+ABBR_FUNCTIONS[$word] )); then
        LBUFFER=$before$($ABBR_FUNCTIONS[$word])
    fi
}

_abbr_space() { _abbr_expand; zle self-insert }
_abbr_accept() { _abbr_expand; zle accept-line }
_abbr_literal_space() { LBUFFER+=' ' }
zle -N _abbr_space
zle -N _abbr_accept
zle -N _abbr_literal_space

bindkey ' ' _abbr_space
bindkey '^M' _abbr_accept
bindkey '^@' _abbr_literal_space # Ctrl-Space
bindkey -M isearch ' ' self-insert
