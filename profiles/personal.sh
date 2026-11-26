# Personal laptop (the 2015 MacBook Pro) profile.
# Plain assignments only: sourced by bash (scripts/functions.sh, bin/) and zsh (zsh/.zprofile).

PROFILE=personal                       # Name of profiles
HOME_REPO="$HOME/dotfiles"             # Location of home_repo
TERMINAL=iterm2                        # Ghostty doesn't work on older laptops
LOCAL_CLUSTER=false                    # No cluster on old laptop. Not enough memory
PACKAGE_MANAGER=macports               # Package manager of choice
SSH_KEY="$HOME/.ssh/id_ed25519"        # Location of public SSH key
SKIP_MODULES="ghostty"           # List of space-separated modules to skip
