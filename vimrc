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

"文件类型选项
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

"补全时忽略大小写
set wildignorecase

"检索时的大小写处理
set ignorecase
set smartcase
set tagcase=match
set mouse=r
