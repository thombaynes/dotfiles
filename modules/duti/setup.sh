#!/usr/bin/env bash

DIR=$(dirname "$0")
cd "$DIR"

. ../../scripts/functions.sh

profile_guard

if ! command -v duti > /dev/null 2>&1; then
    error "duti is not installed. Install it with the packages module (make packages)."
    exit 1
fi

info "Setting default applications using duti..."

# Bundle IDs aren't case-sensitive, so compare the current one without case
shopt -s nocasematch

# Counts the apps skipped and the defaults that failed. The loop reads from a process substitution, not a pipe, so it can set this
PROBLEMS=0

while read fn; do
    # duti -s fails for an app that isn't installed, and a dry run can't tell that from a different default app
    if [ -z "$(mdfind "kMDItemCFBundleIdentifier == '$fn'" | head -1)" ]; then
        substep_error "$fn is not installed, so its extensions were skipped."
        PROBLEMS=$((PROBLEMS + 1))
        continue
    fi
    while read -r ext || [ -n "$ext" ]; do
        # duti -x prints the current app's name, path and bundle ID
        if [[ "$(duti -x "$ext" 2>/dev/null | sed -n 3p)" == "$fn" ]]; then
            continue
        elif dry_run; then
            would "open $ext with $fn"
        else
            substep_info "Setting default application for extension $ext to $fn..."
            duti -s $fn $ext all || { substep_error "Failed to set $fn as the default for $ext."; PROBLEMS=$((PROBLEMS + 1)); }
        fi
    done < $fn
done < <(find * -not -name "$(basename ${0})" -type f)

shopt -u nocasematch

if [ "$PROBLEMS" -eq 0 ]; then
    success "Successfully set all default applications."
else
    error "Finished, but $PROBLEMS skipped or failed. See the errors above."
fi
