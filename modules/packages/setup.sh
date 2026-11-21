#!/usr/bin/env bash

DIR=$(dirname "$0")
cd "$DIR"

. ../../scripts/functions.sh

COMMENT=\#*

# PACKAGE_MANAGER picks brew or MacPorts, and the Brewfile reads TERMINAL from it
profile_guard

# MacPorts installs to /opt/local, which is often not on PATH in a non-login shell
PATH="$PATH:/opt/local/bin"

dry_run || sudo -v

if [ "$PACKAGE_MANAGER" = brew ]; then
    if ! command -v brew > /dev/null 2>&1; then
        error "Profile '$PROFILE' uses Homebrew, but it is not installed. See https://brew.sh"
        exit 1
    fi
    if dry_run; then
        # brew bundle installs and upgrades, and check reports both, one "→ ..." line each
        HOMEBREW_TERMINAL="$TERMINAL" brew bundle check --verbose 2>&1 | while read -r line; do
            case "$line" in
                "→ "*" needs to be installed or updated.")
                    line="${line#→ }"
                    would "install or update ${line% needs to be installed or updated.}" ;;
                "→ "*)
                    would "fix: ${line#→ }" ;;
            esac
        done
    else
        info "Installing Brewfile packages..."
        HOMEBREW_TERMINAL="$TERMINAL" brew bundle
        success "Finished installing Brewfile packages."
    fi
elif [ "$PACKAGE_MANAGER" = macports ]; then
    if ! command -v port > /dev/null 2>&1; then
        error "Profile '$PROFILE' uses MacPorts, but it is not installed. See https://www.macports.org/install.php"
        exit 1
    fi
    # Casks alongside MacPorts are fine, but brew formulae would clash with ports
    if command -v brew > /dev/null 2>&1 && [ -n "$(brew list --formula 2> /dev/null)" ]; then
        error "Homebrew has formulae installed, which clash with MacPorts. Uninstall them (casks are OK) and try again."
        exit 1
    fi
    dry_run || info "Installing Portlist packages..."
    while read package; do
        if [[ $package == $COMMENT ]] || [ -z "$package" ]; then
            continue
        fi
        if dry_run; then
            # port install doesn't upgrade, so only a missing port is a change
            [ -n "$(port -q installed "$package" < /dev/null 2>/dev/null)" ] || would "install $package"
            continue
        fi
        substep_info "Installing or updating $package..."
        if ! sudo port -N install "$package"; then
            substep_error "Failed to install $package."
        fi
    done < Portlist
    success "Finished installing Portlist packages."
else
    error "Unknown PACKAGE_MANAGER '$PACKAGE_MANAGER' in profile '$PROFILE'. Expected brew or macports."
    exit 1
fi
