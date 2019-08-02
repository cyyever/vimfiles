if !has('win32')
  set runtimepath^=~/.config/nvim/vimfiles runtimepath+=~/.config/nvim/vimfiles/after
  let &packpath = &runtimepath
  source ~/.config/nvim/vimfiles/vimrc
else
  set runtimepath^=~/AppData/Local/nvim/vimfiles runtimepath+=~/AppData/Local/nvim/vimfiles/after
  let &packpath = &runtimepath
  source ~/AppData/Local/nvim/vimfiles/vimrc
endif
