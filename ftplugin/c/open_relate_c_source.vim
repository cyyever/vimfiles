if !exists("*H_open_relate_c_source")
	function! H_open_relate_c_source()
		let l:src_files=[]
		call add(l:src_files,expand("%:p:s?\.h$?.c?"))
		call add(l:src_files,expand("%:p:s?\.h$?.C?"))
		call add(l:src_files,expand("%:p:s?\.h$?.cc?"))

		for l:src_file in l:src_files
			if(filereadable(l:src_file) &&!bufloaded(l:src_file))
				exe 'w'
				exe 'sp '.l:src_file
			endif
		endfor
	endfunction
endif
