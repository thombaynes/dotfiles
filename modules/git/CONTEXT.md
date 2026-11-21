## Git Setup
`.gitconfig`, `.gitignore_global`, and `.githelpers` all live here, and are symlinked into `~`.

Commits and tags are signed with SSH (the profile's `$SSH_KEY.pub`, verified through `~/.ssh/allowed_signers`). Machine-specific identity (name, email) lives in `.personal-gitconfig` and `.auros-gitconfig`.

`setup.sh [personal\|auros]` generates `~/.gitconfig-local`, which `.gitconfig` includes: an include of the profile's identity file plus `user.signingkey`. The profile comes from `profiles/`; passing a name switches it.
