scriptencoding utf-8


" au BufReadPost * if &ma && &fenc !='utf-8' | set fenc=utf-8 | endif

if &diff
  au VimEnter * if &diff | execute 'windo set wrap' | endif
endif


"打开文件跳转到上次阅读地方且居中
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"zz" | endif

"颜色方案
syntax on
set termguicolors


" 拼写检查
let &spellfile=expand('<sfile>:p:h') . '/spell/cyy_dictionary.utf-8.add'
if filereadable(&spellfile) && (!filereadable(&spellfile . '.spl') || getftime(&spellfile) > getftime(&spellfile . '.spl'))
  exec 'mkspell! ' . fnameescape(&spellfile)
endif
set spell
set spelllang=en,cjk,programming,cyy_dictionary
au TermOpen * setlocal nospell


" let s:languagetool_jar=$HOME.'/opt/languagetool/languagetool-commandline.jar'
" if filereadable(s:languagetool_jar)
"   let g:ale_languagetool_executable='java'
"   let g:ale_languagetool_options='-jar '.s:languagetool_jar.' --autoDetect'
" endif
" let g:ale_textlint_options='--rule languagetool'





" let g:instant_markdown_slow = 0
" let g:instant_markdown_autoscroll = 1
" let g:instant_markdown_autostart = 0
" let g:instant_markdown_logfile = tempname()
" Plug 'suan/vim-instant-markdown', {'for': 'markdown'}

" let g:fzf_action = { 'enter': 'split' }
" Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Plug 'junegunn/fzf.vim'

" nnoremap <Leader>sp :GFiles<CR>


" Plug 'voldikss/vim-mma'
