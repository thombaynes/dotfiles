#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

COMMENT=\#*

# MacPorts installs to /opt/local, which is often not on PATH in a non-login shell
PATH="$PATH:/opt/local/bin"

HAS_BREW=false
HAS_PORT=false
command -v brew > /dev/null 2>&1 && HAS_BREW=true
command -v port > /dev/null 2>&1 && HAS_PORT=true

# Casks alongside MacPorts are fine, but brew formulae would clash with ports
if $HAS_BREW && $HAS_PORT; then
    if [ -n "$(brew list --formula 2> /dev/null)" ]; then
        error "MacPorts is installed and Homebrew has formulae installed. Uninstall them (casks are OK) and try again."
        exit 1
    fi
    HAS_BREW=false
fi

sudo -v

if $HAS_BREW; then
    info "Installing Brewfile packages..."
    brew bundle
    success "Finished installing Brewfile packages."
elif $HAS_PORT; then
    info "Installing Portlist packages..."
    while read package; do
        if [[ $package == $COMMENT ]] || [ -z "$package" ]; then
            continue
        fi
        substep_info "Installing or updating $package..."
        if ! sudo port -N install "$package"; then
            substep_error "Failed to install $package."
        fi
    done < Portlist
    success "Finished installing Portlist packages."
else
    error "Neither Homebrew nor MacPorts is installed."
    exit 1
fi

find * -name "*.list" | while read fn; do
    cmd="${fn%.*}"
    set -- $cmd
    info "Installing $1 packages..."
    while read package; do
        if [[ $package == $COMMENT ]];
            then continue
        fi
        substep_info "Installing or updating $package..."
        $cmd $package
    done < "$fn"
    success "Finished installing $1 packages."
done
