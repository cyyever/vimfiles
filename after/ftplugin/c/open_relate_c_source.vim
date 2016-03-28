if !exists("*H_open_relate_c_source")
	function! H_open_relate_c_source()
		let c_file=expand("%:p:s?\.h$?.c?")
		if(!filereadable(c_file))
			let c_file=expand("%:p:s?\.h$?.C?")
		endif
		if(!filereadable(c_file))
			let c_file=expand("%:p:s?\.h$?.cpp?")
		endif
		if(!filereadable(c_file))
			let c_file=expand("%:p:s?\.h$?.cxx?")
		endif
		if(!bufloaded(c_file))
			exe 'w'
			exe 'sp '.c_file
		endif
	endfunction
endif
