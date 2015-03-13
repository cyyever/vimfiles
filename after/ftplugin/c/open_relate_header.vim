if !exists("*C_open_relate_header")
	function! C_open_relate_header()
		let header_file=expand("%:p:s?\.c$?.h?")
		if(!bufloaded(header_file))
			exe 'w'
			exe 'sp '.header_file
		endif
	endfunction
endif
