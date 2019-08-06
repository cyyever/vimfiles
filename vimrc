"设置写入文件编码
set fileencodings=utf-8,chinese
"设置编码
set encoding=utf-8
scriptencoding utf-8

let s:vimrc=expand('<sfile>:p')
let s:vimrc_dir=expand('<sfile>:p:h')
let s:vimrc_update_tag_path=s:vimrc_dir.'/.update_tag'
if !filereadable(s:vimrc_update_tag_path) || localtime() > getftime(s:vimrc_update_tag_path)+3600
  if executable('git')
    call writefile([],s:vimrc_update_tag_path)
    call system('cd '.s:vimrc_dir.' && git pull && git submodule update --init')
	if !v:shell_error
      source %
	endif
  endif
endif

if !has('nvim')
  "不要兼容vi
  set nocompatible
endif

"备份文件
set backup
if has('nvim')
  let s:back_dir=stdpath('data').'/backup//'
  if !isdirectory(s:back_dir)
    call mkdir(s:back_dir)
  endif
  let &backupdir=s:back_dir
endif

let $PATH = $HOME.'/opt/node_modules/.bin:'.$HOME.'/opt/bin:'.$HOME.'/opt/gopath/bin:'.$HOME.'/opt:'.$PATH
if has('win32')
  let $PATH= substitute($PATH, '/', '\','g')
  let $PATH= substitute($PATH, ':', ';','g')
endif

"增加检索路径
set path+=$HOME/opt/bin,$HOME/opt/include

"文件类型选项
let g:sql_type_default = 'mysql'
filetype plugin on
filetype indent on

"颜色方案
if has('nvim')
  set termguicolors
endif
if exists('$eink')
  colorscheme eink
else
  colorscheme mycolor
endif

"设置页号
set number

"状态栏
set laststatus=2
set statusline=%F%50l:%c/%L
set showcmd

"递增查询
set incsearch
"检索高亮
set hlsearch

"打开文件跳转到上次阅读地方且居中
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"zz" | endif
"关键字搜索当前目录
set complete+=k*

"插入模式可以使用退格
set backspace=indent,eol,start

"缩进宽度
set shiftwidth=2
set tabstop=4 expandtab

"补全选项
set wildignorecase
set infercase

"检索时的大小写处理
set ignorecase
set smartcase
set tagcase=match

"鼠标
if has('nvim')
  set mouse=nv
else
  set mouse=r
endif

set wildignore+=*.o,*.obj,*.git

" python
let g:loaded_python_provider = 1
if has('win32')
  if executable('python')
    let g:python3_host_prog=exepath('python')
  endif
else
  if executable('python3')
    let g:python3_host_prog=exepath('python3')
  endif
endif

" 拼写检查
set shellslash
set spelllang=en,cjk
let &spellfile=expand('<sfile>:p:h') . '/spell/programming.utf-8.add'
if filereadable(&spellfile) && (!filereadable(&spellfile . '.spl') || getftime(&spellfile) > getftime(&spellfile . '.spl'))
  exec 'mkspell! ' . fnameescape(&spellfile)
endif
set spell

" 插件
let g:vim_plug_dir=expand('<sfile>:p:h') . '/plugged'
call plug#begin(g:vim_plug_dir)

" English grammar checking
let g:languagetool_jar=$HOME.'/opt/LanguageTool-4.4.1/languagetool-commandline.jar'
if exists(g:languagetool_jar)
  Plug 'dpelle/vim-LanguageTool'
endif

Plug 'lervag/vimtex'

if executable('ctags')
  let g:gutentags_project_root = ['Makefile']
  Plug 'ludovicchabant/vim-gutentags'
endif

Plug 'w0rp/ale'
let g:ale_lint_on_text_changed='never'
let g:ale_echo_msg_format = '[%linter%] %code: %%s'
let g:ale_fixers = {
      \   '*': ['remove_trailing_lines', 'trim_whitespace'],
      \}
let g:ale_fix_on_save = 1
let g:ale_open_list = 1
let g:ale_list_window_size = 5

augroup CloseLoclistWindowGroup
  autocmd!
  autocmd QuitPre * if empty(&buftype) | lclose | endif
augroup END

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1
Plug 'deoplete-plugins/deoplete-jedi'
if !has('win32')
  let g:deoplete#sources#clang#libclang_path='/usr/lib/llvm-8/lib/libclang.so'
endif
Plug 'deoplete-plugins/deoplete-clang'

"if !has('win32')
" " Plug 'Valloric/YouCompleteMe',{'branch':'master' ,'do':'cd \"'.g:vim_plug_dir.'/YouCompleteMe/third_party/ycmd/cpp\";mkdir -p build;cd build;cmake -DPATH_TO_LLVM_ROOT=/usr/lib/llvm-8/ -DUSE_PYTHON2=off ..;make'}
"else
" " Plug 'Valloric/YouCompleteMe' ,{'branch':'master' ,'do':'cd \"'.g:vim_plug_dir.'/YouCompleteMe/third_party/ycmd/cpp\";mkdir build;cd build;cmake -DUSE_PYTHON2=off -DPATH_TO_LLVM_ROOT=\"C:/Program Files/LLVM\" .. ;cmake --build . --config release'}
"endif

call plug#end()

let s:vim_plug_update_tag_path=g:vim_plug_dir.'/.update_tag'
if !isdirectory(g:vim_plug_dir)  || !filereadable(s:vim_plug_update_tag_path) || getftime(expand('<sfile>:p')) > getftime(s:vim_plug_update_tag_path)+3600
  PlugUpdate!
  call writefile([],s:vim_plug_update_tag_path)
endif

"if exists('*gutentags#statusline')
"  set statusline+=\ %{gutentags#statusline()}
"endif

"if exists('g:ycm_semantic_triggers')
"  let g:ycm_semantic_triggers =  {
"        \ 'c,cpp,python,java,go,erlang,perl': ['re!\w{3}'],
"        \ 'cs,lua,javascript': ['re!\w{3}'],
"        \ }
"endif
