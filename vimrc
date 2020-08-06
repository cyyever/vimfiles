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

" set path
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

" 插件
let g:vim_plug_dir=expand('<sfile>:p:h') . '/plugged'
call plug#begin(g:vim_plug_dir)

Plug 'morhetz/gruvbox'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'wellle/targets.vim'

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
let g:ale_textlint_options='--rule languagetool'

augroup CloseLoclistWindowGroup
  autocmd!
  autocmd QuitPre * if empty(&buftype) | lclose | endif
augroup END
Plug 'cyyever/ale', { 'branch': 'cyy' }


if has('win32')
  Plug 'PProvost/vim-ps1'
endif

" remove sections
let g:airline_section_b=''
let g:airline_section_x=''
let g:airline_extensions = []
Plug 'vim-airline/vim-airline'

if !has('win32')
  Plug 'dag/vim-fish'
endif

let g:ycm_confirm_extra_conf = 0
let g:ycm_global_ycm_extra_conf=s:vimrc_dir.'/ycm_extra_conf.py'
let g:ycm_clangd_binary_path = exepath('clangd')

if !has('win32')
  if filereadable(getcwd().'/compile_commands.json')
    let g:ycm_clangd_args=['--compile-commands-dir='.getcwd()]
  endif
endif

" Plug 'ycm-core/YouCompleteMe', {'dir':$HOME.'/opt/YouCompleteMe'}

" nnoremap <Leader>d :YcmCompleter GoTo<CR>
" nnoremap <Leader>r :YcmCompleter GoToReferences<CR>


Plug 'neoclide/coc.nvim', {'branch': 'release','do': ':CocInstall coc-clangd'}

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('doHover')
nnoremap <Leader>d :call CocActionAsync("jumpDefinition")<CR>
nnoremap <Leader>r :call CocActionAsync("jumpReferences")<CR>
nnoremap <Leader>s :call CocActionAsync("doHover")<CR>
let g:vimtex_compiler_progname = 'nvr'

if !has('win32')
  let g:vimtex_view_method = 'zathura'
  let g:vimtex_view_zathura_options = '-c ~/opt/cli_tool_configs'
else
  let g:vimtex_view_general_viewer = 'SumatraPDF'
  let g:vimtex_view_general_options = '-zoom 200 -reuse-instance -forward-search @tex @line @pdf'
endif

let g:tex_flavor='latex'
Plug 'lervag/vimtex'
augroup vimtex_config
  autocmd!
  autocmd User VimtexEventInitPost VimtexCompile
  autocmd User VimtexEventInitPost let g:vimtex_compiler_latexmk = {'build_dir' : tempname()}
  " autocmd User VimtexEventInitPost let g:ycm_semantic_triggers.tex=g:vimtex#re#youcompleteme
  autocmd User VimtexEventInitPost nnoremap <Leader>v :VimtexView<CR>
augroup end

if g:use_eink==0
  let g:c_no_bracket_error=1
  let g:c_no_curly_error=1
  Plug 'octol/vim-cpp-enhanced-highlight'
  let g:semshi#mark_selected_nodes=0
  Plug 'numirias/semshi'
endif

let g:instant_markdown_slow = 0
let g:instant_markdown_autoscroll = 1
let g:instant_markdown_autostart = 0
let g:instant_markdown_logfile = tempname()
Plug 'suan/vim-instant-markdown', {'for': 'markdown'}

let g:fzf_action = { 'enter': 'split' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

nnoremap <Leader>sp :GFiles<CR>

if g:use_eink==0
  let g:rainbow_active=1
  Plug 'luochen1990/rainbow'
endif

Plug 'jiangmiao/auto-pairs'
" Plug 'zxqfl/tabnine-vim'
call plug#end()
let s:vim_plug_update_tag_path=g:vim_plug_dir.'/.update_tag.eink.'.float2nr(g:use_eink)
if !isdirectory(g:vim_plug_dir)  || !filereadable(s:vim_plug_update_tag_path) || getftime(expand('<sfile>:p')) > getftime(s:vim_plug_update_tag_path)+3600
  PlugUpgrade
  PlugUpdate!
  call writefile([],s:vim_plug_update_tag_path)
endif
if g:use_eink==1
  colorscheme eink
else
  " set background=light
  colorscheme gruvbox
endif
