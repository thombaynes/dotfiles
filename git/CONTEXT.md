## Git Setup
`.gitconfig`, `.gitignore_global`, and `.githelpers` all live here, and are symlinked into `~`.

Machine-specific identity (name, email, signing key) lives in `.personal-gitconfig` and `.usertesting-gitconfig`.

`setup.sh [personal\|usertesting]` symlinks one to `~/.gitconfig-local`, which `.gitconfig` includes. |
