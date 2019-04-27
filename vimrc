"不要兼容vi
set nocompatible
"备份文件
set backup
set dir=.

"设置编码
if has("multi_byte")
  "设置写入文件编码
  set fencs=utf-8,chinese
  set enc=utf-8
else
  echo "no multi_byte support"
endif

"增加检索路径
set path+=$HOME/opt/bin,$HOME/opt/include

"文件类型选项
let g:sql_type_default = 'mysql'
filetype plugin on
filetype indent on

"颜色方案
colorscheme mycolor

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
set cpt+=k*

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
set mouse=r

set wildignore+=*.o,*.obj,*.git


" 拼写检查
set shellslash
set spelllang=en,cjk
let &spellfile=expand("<sfile>:p:h") . '/spell/programming.utf-8.add'

autocmd OptionSet spell for sfile in split(&spellfile) | if filereadable(sfile) && (!filereadable(sfile . '.spl') || getftime(sfile) > getftime(sfile . '.spl')) | exec 'mkspell! ' . fnameescape(sfile) | endif | endfor

let g:vim_plug_dir=expand("<sfile>:p:h") . '/plugged'
call plug#begin(g:vim_plug_dir)

" English grammar checking
let g:languagetool_jar=$HOME."/opt/LanguageTool-4.4.1/languagetool-commandline.jar"
Plug 'dpelle/vim-LanguageTool'

let g:gutentags_project_root = ['Makefile']
Plug 'ludovicchabant/vim-gutentags'

Plug 'w0rp/ale'
let g:ale_lint_on_text_changed='never'
let g:ale_echo_msg_format = '[%linter%] %code: %%s'
let g:ale_fixers = {
      \   '*': ['remove_trailing_lines', 'trim_whitespace'],
      \}
let g:ale_fix_on_save = 1
call plug#end()

let s:vim_plug_update_tag_path=g:vim_plug_dir."/.update_tag"
if !isdirectory(g:vim_plug_dir)  || !filereadable(s:vim_plug_update_tag_path) || getftime(expand("<sfile>:p")) > getftime(s:vim_plug_update_tag_path)
  PlugInstall
  let s:a= writefile([],s:vim_plug_update_tag_path)
endif

set statusline+=\ %{gutentags#statusline()}
