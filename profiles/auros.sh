# Work laptop (Apple silicon). One profile per kind of machine; ~/.config/dotfiles/profile.sh links to the active one.
# Plain assignments only: sourced by bash (scripts/functions.sh, bin/) and zsh (zsh/.zprofile).

PROFILE=auros                    # Picks git/.auros-gitconfig for name and email
HOME_REPO="$HOME/foundry"        # Workspace scanned by local-branches and worktree-cleanup
TERMINAL=ghostty                 # ghostty or iterm2: the one the Brewfile installs
PACKAGE_MANAGER=brew             # brew or macports
SSH_KEY="$HOME/.ssh/id_ed25519"  # Private key. Git signs with $SSH_KEY.pub, and pubkey copies it
