#!/usr/local/bin/fish
set -x -g TERM "xterm-256color"

set -g fish_user_paths "/usr/local/opt/openssl/bin" $fish_user_paths
set -g fish_user_paths "/usr/local/opt/curl/bin" $fish_user_paths
set -g fish_user_paths "/usr/local/opt/postgresql/bin" $fish_user_paths
set -g fish_user_paths "/usr/local/opt/imagemagick@6/bin" $fish_user_paths

set -x -g LC_ALL en_CA.UTF-8
set -x -g LANG en_CA.UTF-8
source ~/.asdf/asdf.fish

# https://stackoverflow.com/questions/26208231/modifying-path-with-fish-shell The top answer says to use a command, but after fish 3.X we can put PATH stuff here and it will not add it repeatedly
set fish_user_paths ./bin $fish_user_paths
