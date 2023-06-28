"
"	程序名：comment_block.vim
"	作者：陈源源
"	日期：2013-02-08
"	功能：注释块相关函数
"
scripte utf-8

function! Comment_begin_block()
	if &filetype=="c" || &filetype=="cpp"
		return '/*!'
	else
		return Comment_in_block()
endfunction

function! Comment_in_block()
	if &filetype=="c" || &filetype=="cpp"
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
	if &filetype=="c" || &filetype=="cpp"
		return ' */'
	else
		return Comment_in_block()
	endif
endfunction

function! Comment_header()
	let file_content=[Comment_begin_block(),Comment_in_block()." \\file ".expand("%:t"),Comment_in_block(),Comment_in_block()." \\brief",Comment_end_block()]
	call append(0,file_content)
endfunction
