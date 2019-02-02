"语法高亮
syntax on
"设置终端颜色
if &term == "xterm-color"
  set term=xterm-256color
endif
highlight Normal ctermbg=black
highlight Comment ctermfg=green
highlight PreProc ctermfg=darkgrey
highlight LineNr ctermfg=cyan
highlight Statement ctermfg=cyan
highlight StatusLine cterm=italic ctermbg=black ctermfg=yellow
highlight Search ctermbg=cyan ctermfg=yellow
highlight Visual ctermbg=darkgreen ctermfg=black
highlight htmlLink ctermfg=green
highlight Identifier ctermbg=black ctermfg=LightYellow
