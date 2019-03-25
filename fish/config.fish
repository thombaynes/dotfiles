set -x -g TERM "xterm-256color"

set -g fish_user_paths "/usr/local/opt/openssl/bin" $fish_user_paths
set -g fish_user_paths "/usr/local/opt/curl/bin" $fish_user_paths
set -g fish_user_paths "/usr/local/opt/postgresql/bin" $fish_user_paths

set -x -g LC_ALL en_CA.UTF-8
set -x -g LANG en_CA.UTF-8
source ~/.asdf/asdf.fish
