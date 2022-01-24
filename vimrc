set encoding=utf-8

scriptencoding utf-8

if !has('nvim')
  echo 'This is a nvim only configuration.'
  exit
endif

"设置写入文件编码
set fileencodings=utf-8,gb18030,cp950,euc-tw
au BufReadPost * if &ma && &fenc !='utf-8' | set fenc=utf-8 | endif

let s:vimrc=expand('<sfile>:p')
let s:vimrc_dir=expand('<sfile>:p:h')
let s:vimrc_update_tag_path=s:vimrc_dir.'/.update_tag'
if !filereadable(s:vimrc_update_tag_path) || localtime() > getftime(s:vimrc_update_tag_path)+3600
  if executable('git')
    call writefile([],s:vimrc_update_tag_path)
    call system('cd '.s:vimrc_dir.' && git pull && git submodule update --init')
	if !v:shell_error
      exec 'source '.s:vimrc
    endif
  endif
endif

" diff
set diffopt+=horizontal,algorithm:patience
if &diff
  au VimEnter * if &diff | execute 'windo set wrap' | endif
endif

"备份文件
set backup
let s:back_dir=stdpath('data').'/backup//'
if !isdirectory(s:back_dir)
  call mkdir(s:back_dir)
endif
let &backupdir=s:back_dir

" set path
let $PATH = $HOME.'/opt/python/bin::'.$HOME.'/opt/pip/bin::'.$HOME.'/opt/node_modules/.bin::'.$HOME.'/opt/bin::'.$HOME.'/opt/gopath/bin::'.$HOME.'/opt::'.$HOME.'/.local/bin::'.$PATH
if has('win32')
  let $PATH= substitute($PATH, '/', '\','g')
  let $PATH= substitute($PATH, '::', ';','g')
else
  let $PATH= substitute($PATH, '::', ':','g')
endif

"增加检索路径
set path+=$HOME/opt/bin,$HOME/opt/include

"文件类型选项
let g:sql_type_default = 'mysql'
filetype plugin on
filetype indent on

"设置页号
set number
set showcmd

"递增查询
set incsearch
set inccommand=nosplit
"检索高亮
set hlsearch

set autoread

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
set mouse=nv

set wildignore+=*.o,*.obj,*.git

" provider
let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0
let g:loaded_node_provider = 0
let g:loaded_python_provider = 0

if has('win32')
  if executable('python')
    let g:python3_host_prog=exepath('python')
  endif
else
  if executable('python3')
    let g:python3_host_prog=exepath('python3')
  endif
endif

"颜色方案
syntax on
set termguicolors

let g:use_eink=0
if exists('$eink_screen') && $eink_screen==1
  let g:use_eink=1
endif

" there are some bugs in nvim cursor code, so I disable it.
set guicursor=

" shell
set noshellslash

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

let mapleader = ';'

if g:use_eink==1
  colorscheme eink
else
  " set background=light
  colorscheme gruvbox
endif
