#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

COMMENT=\#*
DIRECTORY=\D*
REPO_PATH=$(realpath ~/repos)

find * -name "*.list" | while read fn; do
    folder="${fn%.*}"

    info "Cloning $folder repositories..."

    substep_info "Creating $folder folder..."
    mkdir -p "$REPO_PATH/$folder"
    while read repo; do
        if [[ $repo == $DIRECTORY ]]; then
            actual_dir=${repo:2}
            substep_info "Creating $actual_dir sub-folder..."
            mkdir -p "$REPO_PATH/$folder/$actual_dir"
        elif [[ $repo == $COMMENT ]];
        then continue; else
            pushd "$REPO_PATH/$folder" &> /dev/null
            git clone $repo $name
            if [[ $? -eq 128 ]]; then
                substep_success "$repo already exists."
            # For some reason all the repos return an exit code of 1. My googling seems to indicate this is a new line issue (Windows instead of Unix) - https://codefresh.io/docs/docs/troubleshooting/common-issues/git-clone-step-issue/
            elif [[ $? -eq 0 ]] || [[ $? -eq 1 ]]; then
                substep_success "Cloned $repo."
            else
                substep_error "$? Failed to clone $repo."
            fi
#            TODO asdf install - erlang takes so long to run the first time do we want to do this?
            popd &> /dev/null
        fi
    done < "$fn"
    success "Finished cloning $folder repositories."
done
