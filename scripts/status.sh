#!/usr/bin/env bash

# Read-only report of what each module's setup.sh would change, by running it in a dry run (see dry_run in functions.sh).
#   status.sh module...     one line per module
#   status.sh -v module...  also every change, as each setup.sh reports it
# Exits 1 when anything would change.

DIR=$(dirname "$0")
cd "$DIR/.."

. scripts/functions.sh

VERBOSE=""
if [ "$1" = -v ]; then
    VERBOSE=1
    shift
fi

# load_profile would ask for one, and a status check shouldn't change anything
if [ ! -e "$PROFILE_LINK" ]; then
    error "No profile linked at $PROFILE_LINK. Pick one with make profile NAME=<name>."
    exit 1
fi
load_profile

DRIFTED=""
for module in "$@"; do
    if ! in_profile "$module"; then
        substep_info "$module: skipped - not part of the $PROFILE profile"
        continue
    fi
    OUTPUT="$(DOTFILES_DRY_RUN=1 "./modules/$module/setup.sh" 2>&1)"
    STATUS=$?
    [ -n "$VERBOSE" ] && echo "$OUTPUT"
    CHANGES=$(grep -c '==== Would ' <<< "$OUTPUT")
    if [ "$STATUS" -ne 0 ]; then
        DRIFTED=1
        substep_error "$module: dry run failed. See make status-$module."
    elif [ "$CHANGES" -eq 1 ]; then
        DRIFTED=1
        substep_error "$module: 1 change"
    elif [ "$CHANGES" -gt 1 ]; then
        DRIFTED=1
        substep_error "$module: $CHANGES changes"
    else
        substep_success "$module: in sync"
    fi
done

if [ -n "$DRIFTED" ]; then
    error "make <module> applies a module's changes, and make status-<module> lists them."
    exit 1
fi
success "Everything is in sync."
