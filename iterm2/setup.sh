# Run these commands to add bold and italics to the terminfo database, allowing italics
# Test by running:
# echo `tput sitm`italics`tput ritm`
tic -x tmux-256color.terminfo.txt
tic -x xterm-256color-italic.terminfo.txt

