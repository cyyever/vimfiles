set notermguicolors
for group_name in [ 'Normal','Constant','Delimiter','Special','Directory','LineNR','Type']
  exec 'highlight '.group_name.' ctermfg=black ctermbg=white guifg=black guibg=white'
endfor

for group_name in [ 'Pmenu','Identifier','PreProc','Statement' ]
  exec 'highlight '.group_name.' cterm=bold ctermfg=black ctermbg=white guifg=black guibg=white'
endfor

if !has('win32')
  highlight Search ctermfg=white ctermbg=black guifg=white guibg=black
  highlight IncSearch ctermfg=white ctermbg=black guifg=white guibg=black
endif

highlight Comment ctermfg=black ctermbg=white guifg=black guibg=white
for group_name in ['SpellBad','SpellCap', 'Underlined']
  exec 'highlight '.group_name.' cterm=underline ctermfg=black ctermbg=white guifg=black guibg=white'
endfor
