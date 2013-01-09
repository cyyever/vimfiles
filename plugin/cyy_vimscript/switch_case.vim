"把光标下的单词转大小写

function Switch_case()
	let save_cursor = getpos(".")
	let validletter="[a-zA-Z0-9_]" "token合法字符
	let curline=getline('.')
	let col=save_cursor[2]
	let cur_char=getline('.')[save_cursor[2]-1]
	if match(cur_char,validletter)==-1
		return 
	endif
	let cword=expand("<cword>")
	if cur_char =~ '[a-z]' " 第一个字符是小写
		let cword=toupper(cword)
	else
		let cword=tolower(cword)
	endif

	exec "normal caw".cword
	call setpos('.', save_cursor)
endfunction
