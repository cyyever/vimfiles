"不要兼容vi
set nocompatible
"备份文件
set backup
"使用文件类型插件
filetype plugin on

if has("multi_byte")
	"设置写入文件编码
	set fencs=utf-8,chinese
	set enc=chinese
else
	echo "no multi_byte support"
endif

"语法高亮
syntax on
"递增查询
set incsearch
"设置页号
set nu
"打开文件跳转到上次阅读地方
autocmd BufReadPost * call cursor(line("'\""),1)
"检索高亮
set hlsearch
"映射到切换大小写
nmap . :call Switch_case()<cr>

"关键字搜索当前目录
set cpt+=k*
" 状态栏
set laststatus=2
set statusline=%F%50l:%c/%L

"插入模式可以使用退格
set backspace=indent,eol,start
