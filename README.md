# Dotfiles

## Usage
1. Restore your safely backed up ssh keys to `~/.ssh/`
    1. Alternatively, generate new ssh keys, and add these to your GitHub account
2. Install (Homebrew or Macports) and git
3. Clone this repository
4. Run the `bootstrap.sh` script. It asks which profile this machine uses (`personal` or `auros`, see `profiles/`), or pass it: `./bootstrap.sh personal`
    1. Alternatively, only run the `setup.sh` scripts in specific subfolders if you don't need everything (see [AGENTS.md](AGENTS.md))

## Contents
See [AGENTS.md](AGENTS.md) for what each folder contains.

### Notes from the original authour

For more information about dotfiles, read these posts from his blog.
* [Dotfiles: automating macOS system configuration](https://kalis.me/dotfiles-automating-macos-system-configuration/)
* [Increasing development productivity with repository management](https://kalis.me/increasing-development-productivity-repository-management/)
* [Set up a Hyper Key with Hammerspoon on macOS](https://kalis.me/setup-hyper-key-hammerspoon-macos/)
