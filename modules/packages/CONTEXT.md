# packages

Older Macs use MacPorts (`Portlist`) and newer Macs use Homebrew (`Brewfile`). The profile's `PACKAGE_MANAGER` picks one, and `setup.sh` installs from it.

## Adding or removing a package

- Consider both managers. If it isn't clear whether a package belongs in one or both, ask the user.
- MacPorts has a narrower range than Homebrew. Check whether the package exists there (`port search`, or https://ports.macports.org) and tell the user what you found, so they can decide. Port names often differ or are versioned (`terraform-1.17`, `helm-4.3`). Packages with no port go in the "No port" comments at the bottom of `Portlist`.
- Kubernetes tools are Homebrew only (see the comment in `Portlist`).

## Variables that change what installs

`setup.sh` passes profile values to brew as `HOMEBREW_*`, because brew drops other variables. The Brewfile reads them:

- `HOMEBREW_TERMINAL` (from `TERMINAL`): `ghostty` or `iterm2` installs only that terminal.
- `HOMEBREW_LOCAL_CLUSTER` (from `LOCAL_CLUSTER`): `false` skips the Kubernetes tools. Unset installs everything, as in a hand-run `brew bundle`.
