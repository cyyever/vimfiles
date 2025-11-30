scriptencoding utf-8


au BufReadPost * if &ma && &fenc !='utf-8' | set fenc=utf-8 | endif

if &diff
  au VimEnter * if &diff | execute 'windo set wrap' | endif
endif


"打开文件跳转到上次阅读地方且居中
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"zz" | endif



" 拼写检查
let &spellfile=expand('<sfile>:p:h') . '/spell/cyymine.utf-8.add'
if filereadable(&spellfile) && (!filereadable(&spellfile . '.spl') || getftime(&spellfile) > getftime(&spellfile . '.spl'))
  exec 'mkspell! ' . fnameescape(&spellfile)
endif
set spell
set spelllang=en,cjk,cyymine
