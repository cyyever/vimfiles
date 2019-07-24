if !has('win32')
  set runtimepath^=~/.config/nvim/vimfiles runtimepath+=~/.config/nvim/vimfiles/after
  let &packpath = &runtimepath
  source ~/.config/nvim/vimfiles/vimrc
endif
