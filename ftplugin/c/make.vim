function! C_make()
	let dir_name=expand('%:p:h')
	let flag=0
	if isdirectory(dir_name) 
		for make_file in ['GNUmakefile', 'makefile', 'Makefile']
			if(filereadable(dir_name.'/'.make_file))
				exe 'w'
				exe '!clear && make -C '.dir_name.' 2>&1 | grep -C 10 -e warning -e error '
				let flag=1
			endif
		endfor
	endif
	if flag==0
		exe 'w'
		exe '!clear&&gcc -Wall '.expand('%:p').' 2>&1 | grep -C 10 -e warning -e error '
	endif
endfunction
