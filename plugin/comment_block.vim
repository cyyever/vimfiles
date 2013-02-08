"
"	程序名：comment_block.vim
"	作者：陈源源
"	日期：2013-02-08
"	功能：注释块相关函数
"
scripte utf-8

let s:file_name=expand("%:t")
let s:date=strftime("%Y-%m-%d")

function! Comment_begin_block()
	if &filetype=="c" || &filetype=="h"
		return '/*'
	else
		return Comment_in_block()
endfunction

function! Comment_in_block()
	if &filetype=="c" || &filetype=="h"
		return ' *'
	elseif &filetype=="vim"
		return '"'
	elseif &filetype=="sh" || &filetype=="perl"
		return '#'
	else
		return ''
	endif
endfunction

function! Comment_end_block()
	if &filetype=="c" || &filetype=="h"
		return ' */'
	else
		return Comment_in_block()
	endif
endfunction

function! Comment_header()
	let file_content=[Comment_begin_block(),Comment_in_block()."\t程序名：".s:file_name,Comment_in_block()."\t作者：陈源源",Comment_in_block()."\t日期：".s:date,Comment_in_block()."\t功能：",Comment_end_block()]
	call append(0,file_content)
endfunction

