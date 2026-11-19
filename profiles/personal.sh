# Personal laptop (the 2015 MacBook Pro). One profile per kind of machine; ~/.config/dotfiles/profile.sh links to the active one.
# Plain assignments only: sourced by bash (scripts/functions.sh, bin/) and zsh (zsh/.zprofile).

PROFILE=personal                 # Picks git/.personal-gitconfig for name and email
HOME_REPO="$HOME/dotfiles"                     # Workspace scanned by local-branches and worktree-cleanup. None here yet
TERMINAL=iterm2                  # ghostty or iterm2. Ghostty doesn't support this Mac
PACKAGE_MANAGER=macports         # brew or macports
SSH_KEY="$HOME/.ssh/id_ed25519"  # Private key. Git signs with $SSH_KEY.pub, and pubkey copies it
