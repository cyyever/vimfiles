
scriptencoding utf-8



" au BufReadPost * if &ma && &fenc !='utf-8' | set fenc=utf-8 | endif

if &diff
  au VimEnter * if &diff | execute 'windo set wrap' | endif
endif


" let &backupdir=s:back_dir

" set path
let $PATH ='/usr/bin/vendor_perl:'.$HOME.'/opt/python/bin:'.$HOME.'/opt/node_modules/.bin:'.$HOME.'/opt/bin:'.$HOME.'/opt/gopath/bin:'.$HOME.'/opt:'.$HOME.'/.local/bin:'.$PATH
if has('win32')
  let $PATH= substitute($PATH, '/', '\','g')
  let $PATH= substitute($PATH, ':\+', ';','g')
else
  let $PATH= substitute($PATH, ':\+', ':','g')
endif

"增加检索路径
set path+=$HOME/opt/bin,$HOME/opt/include



"打开文件跳转到上次阅读地方且居中
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"zz" | endif
"关键字搜索当前目录
set complete+=k*

"缩进宽度
set shiftwidth=4
set tabstop=4 expandtab

"补全选项
set wildignorecase
set infercase

"检索时的大小写处理
set ignorecase
set smartcase
set tagcase=match

set wildignore+=*.o,*.obj,*.git

"颜色方案
syntax on
set termguicolors


" 拼写检查
set spelllang=en,cjk
let &spellfile=expand('<sfile>:p:h') . '/spell/programming.utf-8.add'
if filereadable(&spellfile) && (!filereadable(&spellfile . '.spl') || getftime(&spellfile) > getftime(&spellfile . '.spl'))
  exec 'mkspell! ' . fnameescape(&spellfile)
endif
set spell
au TermOpen * setlocal nospell

" 终端模式
tnoremap <Esc> <C-\><C-n>



" let s:languagetool_jar=$HOME.'/opt/languagetool/languagetool-commandline.jar'
" if filereadable(s:languagetool_jar)
"   let g:ale_languagetool_executable='java'
"   let g:ale_languagetool_options='-jar '.s:languagetool_jar.' --autoDetect'
" endif
" let g:ale_textlint_options='--rule languagetool'

" Plug 'cyyever/ale', { 'branch': 'cyy' }




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
