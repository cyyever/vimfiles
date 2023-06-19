
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

"文件类型选项
let g:sql_type_default = 'mysql'
filetype plugin on
filetype indent on


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

" 插件
let g:vim_plug_dir=fnamemodify($MYVIMRC,':p:h') . '/vimfiles/plugged'
call plug#begin(g:vim_plug_dir)


let g:ale_lint_on_text_changed='never'
let g:ale_echo_msg_format = '[%linter%] %code: %%s'
let g:ale_fixers = {
      \   '*': ['remove_trailing_lines', 'trim_whitespace'],
      \}
let g:ale_fix_on_save = 1
let g:ale_open_list = 1
let g:ale_list_window_size = 5
" let s:languagetool_jar=$HOME.'/opt/languagetool/languagetool-commandline.jar'
" if filereadable(s:languagetool_jar)
"   let g:ale_languagetool_executable='java'
"   let g:ale_languagetool_options='-jar '.s:languagetool_jar.' --autoDetect'
" endif
let g:ale_linter_aliases = {'ps1': 'powershell'}
let g:ale_textlint_options='--rule languagetool'

augroup CloseLoclistWindowGroup
  autocmd!
  autocmd QuitPre * if empty(&buftype) | lclose | endif
augroup END
Plug 'cyyever/ale', { 'branch': 'cyy' }


if has('win32')
  let g:vimtex_view_general_viewer = 'SumatraPDF'
  let g:vimtex_view_general_options = '-zoom 200 -reuse-instance -forward-search @tex @line @pdf'
elseif has('mac')
  let g:vimtex_view_method = 'sioyek'
  let g:vimtex_view_sioyek_exe= '/Applications/sioyek.app/Contents/MacOS/sioyek'
else
  let g:vimtex_view_method = 'zathura'
  let g:vimtex_view_zathura_options = '-c ~/opt/cli_tool_configs'
endif

let g:tex_flavor='latex'
" let g:vimtex_build_dir = &backupdir.'/vimtex/'.substitute(substitute(getcwd(), '\', '/','g'),'C:/','/','g')
" let g:vimtex_build_dir= substitute(g:vimtex_build_dir, '[/]\+', '/','g')
"       \ 'build_dir' : g:vimtex_build_dir,
let g:vimtex_compiler_latexmk = {
      \ 'callback' : 1,
      \ 'continuous' : 1,
      \ 'executable' : 'latexmk',
      \ 'hooks' : [],
      \ 'options' : [
        \   '-verbose',
        \   '-file-line-error',
        \   '-synctex=1',
        \   '-interaction=nonstopmode',
        \ ],
        \}

Plug 'lervag/vimtex'
augroup vimtex_config
  autocmd!
  " autocmd User VimtexEventInitPost call system("rm ".join(glob(g:vimtex_build_dir."/**/*.pdf",0,1)))
  " autocmd User VimtexEventInitPost call system("rm ".join(glob(g:vimtex_build_dir."/**/*.bbl",0,1)))
  autocmd User VimtexEventInitPost VimtexCompile
  autocmd User VimtexEventInitPost nnoremap <Leader>v :VimtexView<CR>
  " autocmd User VimtexEventInitPost call system("cp -r ".getcwd().' '.g:vimtex_build_dir)
  " autocmd User VimtexEventInitPost call system("rm -f ".getcwd().'/'.expand('%:t:r').'.pdf')
  " autocmd User VimtexEventCompileSuccess call system("cp ".join(glob(g:vimtex_build_dir."/**/".expand('%:t:r').".pdf",0,1),' ').' '.getcwd())
  " autocmd User VimtexEventCompileSuccess call system("cp ".join(glob(g:vimtex_build_dir."/**/".expand('%:t:r').".bbl",0,1),' ').' '.getcwd())
augroup end

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





call plug#end()

let s:vim_plug_update_tag_path=g:vim_plug_dir.'/.update_tag.eink.'.float2nr(g:use_eink)
if !isdirectory(g:vim_plug_dir)  || !filereadable(s:vim_plug_update_tag_path) || getftime(expand('<sfile>:p')) > getftime(s:vim_plug_update_tag_path)+3600
  PlugUpgrade
  PlugUpdate!
  call writefile([],s:vim_plug_update_tag_path)
endif
