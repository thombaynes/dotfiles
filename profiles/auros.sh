# Work laptop (Apple silicon). One profile per kind of machine; ~/.config/dotfiles/profile.sh links to the active one.
# Plain assignments only: sourced by bash (scripts/functions.sh, bin/) and zsh (zsh/.zprofile).

PROFILE=auros
HOME_REPO="$HOME/home_repo"
TERMINAL=ghostty
PACKAGE_MANAGER=brew
SSH_KEY="$HOME/.ssh/id_ed25519"
SKIP_MODULES="iterm2"                  # List of space-separated modules to skip
