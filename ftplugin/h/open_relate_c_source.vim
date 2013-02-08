if !exists("*H_open_relate_c_source")
	function! H_open_relate_c_source()
		let c_file=expand("%:p:s?\.h$?.c?")
		if(!bufloaded(c_file))
			exe 'w'
			exe 'sp '.c_file
		endif
	endfunction
endif
