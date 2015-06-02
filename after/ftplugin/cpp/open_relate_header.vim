if !exists("*CPP_open_relate_header")
	function! CPP_open_relate_header()
		let header_file=expand('%:p:s?\.\(C\|cpp\)$?.h?')
		echo header_file
		if(!bufloaded(header_file))
			exe 'w'
			exe 'sp '.header_file
		endif
	endfunction
endif
