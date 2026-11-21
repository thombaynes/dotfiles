# Personal laptop (the 2015 MacBook Pro). One profile per kind of machine; ~/.config/dotfiles/profile.sh links to the active one.
# Plain assignments only: sourced by bash (scripts/functions.sh, bin/) and zsh (zsh/.zprofile).

PROFILE=personal
HOME_REPO="$HOME/dotfiles"
TERMINAL=iterm2
LOCAL_CLUSTER=false                      # Whether to install the Kubernetes tools in the Brewfile for a local cluster
PACKAGE_MANAGER=macports
SSH_KEY="$HOME/.ssh/id_ed25519"
SKIP_MODULES="ghostty"
