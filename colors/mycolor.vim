"语法高亮
syntax on
"设置终端颜色
if &term == "xterm-color"
  set term=xterm-256color
endif
highlight Normal ctermbg=black guibg=black
highlight Comment ctermfg=green guifg=green
highlight PreProc ctermfg=darkgrey guifg=darkgrey
highlight LineNr ctermfg=cyan guifg=cyan
highlight Statement ctermfg=cyan guifg=cyan
highlight StatusLine cterm=italic ctermbg=black guibg=black ctermfg=yellow guifg=yellow
highlight Search ctermbg=darkblue guibg=darkblue ctermfg=yellow guifg=yellow
highlight Visual ctermbg=darkgreen guibg=darkgreen ctermfg=black guifg=black
highlight htmlLink ctermfg=green guifg=green
highlight Identifier ctermbg=black guibg=black ctermfg=LightYellow guifg=LightYellow
highlight SpellBad ctermbg=black guibg=black ctermfg=red guifg=red
