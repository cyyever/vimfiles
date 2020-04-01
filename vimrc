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


"备份文件
set backup
let s:back_dir=stdpath('data').'/backup//'
if !isdirectory(s:back_dir)
  call mkdir(s:back_dir)
endif
let &backupdir=s:back_dir

let $PATH = $HOME.'/opt/pip/bin::'.$HOME.'/opt/node_modules/.bin::'.$HOME.'/opt/bin::'.$HOME.'/opt/gopath/bin::'.$HOME.'/opt::'.$HOME.'/.local/bin::'.$PATH
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
" python
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

if exists('$eink_screen') && $eink_screen==1
  colorscheme eink
else
  colorscheme mycolor
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

" 插件
let g:vim_plug_dir=expand('<sfile>:p:h') . '/plugged'
call plug#begin(g:vim_plug_dir)

if executable('latexmk')
  Plug 'lervag/vimtex'
endif

Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'wellle/targets.vim'

" if executable('ctags')
"   let g:gutentags_project_root = ['Makefile']
"   Plug 'ludovicchabant/vim-gutentags'
" endif

Plug 'cyyever/ale', { 'branch': 'cyy' }
let g:ale_lint_on_text_changed='never'
let g:ale_echo_msg_format = '[%linter%] %code: %%s'
let g:ale_fixers = {
      \   '*': ['remove_trailing_lines', 'trim_whitespace'],
      \}
let g:ale_fix_on_save = 1
let g:ale_open_list = 1
let g:ale_list_window_size = 5
let s:languagetool_jar=$HOME.'/opt/languagetool/languagetool-commandline.jar'
if filereadable(s:languagetool_jar)
  let g:ale_languagetool_executable='java'
  let g:ale_languagetool_options='-jar '.s:languagetool_jar.' --autoDetect'
endif
let g:ale_linter_aliases = {'ps1': 'powershell'}
let g:ale_writegood_options='--no-passive'

augroup CloseLoclistWindowGroup
  autocmd!
  autocmd QuitPre * if empty(&buftype) | lclose | endif
augroup END

let g:llvm_dir=''
let g:llvm_version=''
if !has('win32')
  for llvm_version in range(20,9,-1)
    for path in ['/usr/lib/llvm-'.string(llvm_version),'/usr/local/llvm'.string(llvm_version).'0']
      if isdirectory(path)
        let g:llvm_dir=path
        let g:llvm_version=llvm_version
        break
      endif
    endfor
    if !empty(g:llvm_dir)
      break
    endif
  endfor
else
  for path in ['C:/Program Files/LLVM']
    if isdirectory(path)
      let g:llvm_dir=path
    endif
  endfor
endif

if has('win32')
  Plug 'PProvost/vim-ps1'
endif

" remove sections
let g:airline_section_b=''
let g:airline_section_x=''
let g:airline_extensions = []
Plug 'vim-airline/vim-airline'

if !exists('$SSH_CONNECTION')
  let g:keysound_enable = 1
  let g:keysound_py_version = 3
  let g:keysound_volume = 700
  let g:keysound_theme = 'typewriter'
  Plug 'skywind3000/vim-keysound'
endif

if !has('win32')
  Plug 'dag/vim-fish'
endif

Plug 'ycm-core/YouCompleteMe', {'dir':$HOME.'/opt/YouCompleteMe'}

let g:ycm_confirm_extra_conf = 0
let g:ycm_global_ycm_extra_conf=s:vimrc_dir.'/ycm_extra_conf.py'
let g:ycm_clangd_binary_path = exepath('clangd')
nnoremap <Leader>d :YcmCompleter GoTo<CR>
nnoremap <Leader>r :YcmCompleter GoToReferences<CR>

Plug 'octol/vim-cpp-enhanced-highlight'
call plug#end()

let s:vim_plug_update_tag_path=g:vim_plug_dir.'/.update_tag'
if !isdirectory(g:vim_plug_dir)  || !filereadable(s:vim_plug_update_tag_path) || getftime(expand('<sfile>:p')) > getftime(s:vim_plug_update_tag_path)+3600
  PlugUpgrade
  PlugUpdate!
  call writefile([],s:vim_plug_update_tag_path)
endif
