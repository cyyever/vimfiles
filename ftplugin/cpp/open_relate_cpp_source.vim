if !exists("*H_open_relate_cpp_source")
	function! H_open_relate_cpp_source()
		let cpp_file=expand("%:p:s?\.h$?.C?")
		echo cpp_file
		if(!bufloaded(cpp_file))
			exe 'w'
			exe 'sp '.cpp_file
		endif
	endfunction
endif
