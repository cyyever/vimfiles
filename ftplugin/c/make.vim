function! C_make()
	let dir_name=expand('%:p:h')
	if isdirectory(dir_name) 
		let make_cmd='gcc -Wall '.expand('%:p').' 2>&1 | grep -C 10 -e warning -e error '
		for make_file in ['GNUmakefile', 'makefile', 'Makefile']
			if(filereadable(dir_name.'/'.make_file))
				let make_cmd='make -C '.dir_name.' 2>&1 | grep -C 10 -e warning -e error '
				break
			endif
		endfor
	endif
	exe 'w'
	let compiler_output=system(make_cmd)
	echo compiler_output
	
	"补全没有声明的函数
	for line in split(compiler_output,'[\r\n]\+')
		if stridx(line,expand('%:p:t')) != -1
			if stridx(line,"implicit declaration of function") !=-1
				let func_name=substitute(line,".*implicit declaration of function", "", "")
				let func_name=substitute(func_name,'[^a-zA-Z0-9_]\+', "", "g")
				call C_complete_header("f",func_name)
			endif
		endif
	endfor
endfunction
