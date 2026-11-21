#!/usr/bin/env bash

# Read-only report of what each folder's setup.sh would change, by running it in a dry run (see dry_run in functions.sh).
#   status.sh folder...     one line per folder
#   status.sh -v folder...  also every change, as each setup.sh reports it
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
for folder in "$@"; do
    if ! in_profile "$folder"; then
        substep_info "$folder: skipped - not part of the $PROFILE profile"
        continue
    fi
    OUTPUT="$(DOTFILES_DRY_RUN=1 "./$folder/setup.sh" 2>&1)"
    STATUS=$?
    [ -n "$VERBOSE" ] && echo "$OUTPUT"
    CHANGES=$(grep -c '==== Would ' <<< "$OUTPUT")
    if [ "$STATUS" -ne 0 ]; then
        DRIFTED=1
        substep_error "$folder: dry run failed. See make status-$folder."
    elif [ "$CHANGES" -eq 1 ]; then
        DRIFTED=1
        substep_error "$folder: 1 change"
    elif [ "$CHANGES" -gt 1 ]; then
        DRIFTED=1
        substep_error "$folder: $CHANGES changes"
    else
        substep_success "$folder: in sync"
    fi
done

if [ -n "$DRIFTED" ]; then
    error "make <folder> applies a folder's changes, and make status-<folder> lists them."
    exit 1
fi
success "Everything is in sync."
