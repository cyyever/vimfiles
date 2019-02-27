"不要兼容vi
set nocompatible
"备份文件
set backup
set dir=.

set showcmd

set hidden

"设置编码
if has("multi_byte")
	"设置写入文件编码
	set fencs=utf-8,chinese
	set enc=utf-8
else
	echo "no multi_byte support"
endif

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
"递增查询
set incsearch
"打开文件跳转到上次阅读地方
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
"检索高亮
set hlsearch
"关键字搜索当前目录
set cpt+=k*

"插入模式可以使用退格
set backspace=indent,eol,start

"缩进宽度
set shiftwidth=2
set tabstop=4 expandtab

"补全时忽略大小写
set wildignorecase

"检索时的大小写处理
set ignorecase
set smartcase
set tagcase=match
set mouse=r

" 拼写检查
set shellslash
set spelllang=en,cjk
let &spellfile=expand("<sfile>:p:h") . '/spell/programming.utf-8.add'

autocmd OptionSet spell for sfile in split(&spellfile) | if filereadable(sfile) && (!filereadable(sfile . '.spl') || getftime(sfile) > getftime(sfile . '.spl')) | exec 'mkspell! ' . fnameescape(sfile) | endif | endfor

" English grammar checking
if has("win32")
else
  let g:languagetool_jar=$HOME."/languagetool/languagetool-standalone/target/LanguageTool-4.5-SNAPSHOT/LanguageTool-4.5-SNAPSHOT/languagetool-commandline.jar"
endif

" 生成文档
let doc_dir=expand("<sfile>:p:h") ."/doc"

if !filereadable(doc_dir."/tags")
  exec "helptags ".doc_dir
endif
