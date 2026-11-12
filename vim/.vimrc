" Plugins and their mappings only. Everything else has moved to nvim/lua/config/.

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vundle Setup (copied from https://github.com/VundleVim/Vundle.vim)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'tpope/vim-fugitive'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

" Allow you to navigate seamlessly between vim and tmux splits using a consistent set of hotkeys
Plugin 'christoomey/vim-tmux-navigator'
" Allow Vim to know that Tmux exists, and run tmux commands. Open new panes or windows.
Plugin 'christoomey/vim-tmux-runner'

" Brings Ruby stuff. Installed initially for collapsing Ruby blocks, which didn't appear to work, but definitely brought some good functionality
Plugin 'vim-ruby/vim-ruby'
" This works in conjuction with toomey's vim-tmux-runner to run RSpec from within a spec.rb file.
Plugin 'thoughtbot/vim-rspec'
" Better GUI. Mostly here for better communication of modes
Plugin 'vim-airline/vim-airline'
" Allows `FocusGained` and `FocusLost` events to work in VIM inside Tmux.
" What does this actually mean? Allows VIM to reload a file when outside write events to files occur
Plugin 'tmux-plugins/vim-tmux-focus-events'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Rspec runners (vim-rspec)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>t :call RunCurrentSpecFile()<CR>
map <leader>s :call RunNearestSpec()<CR>
map <leader>l :call RunLastSpec()<CR>
map <leader>a :call RunAllSpecs()<CR>
