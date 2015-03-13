function! CPP_make()
	let dir_name=expand('%:p:h')
	let make_cmd='gcc -Wall '.expand('%:p').' 2>&1'
	for make_file in ['GNUmakefile', 'makefile', 'Makefile']
		if(filereadable(dir_name.'/'.make_file))
			let make_cmd='make -C '.dir_name.' 2>&1'
			break
		endif
	endfor
endfunction
