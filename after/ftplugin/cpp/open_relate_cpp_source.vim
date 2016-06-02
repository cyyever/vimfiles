if !exists("*H_open_relate_cpp_source")
	function! H_open_relate_cpp_source()
		let cpp_file=""
		for cpp_suffix in ["C","c","cpp","cc","cxx"]
			if(filereadable(expand("%:p:s?\.h$?.".cpp_suffix."?")))
				let cpp_file=expand("%:p:s?\.h$?.".cpp_suffix."?")
				echo "I am ".cpp_file
				break
			endif
		endfor
		if(cpp_file!="" && !bufloaded(cpp_file))
			exe 'w'
			exe 'sp '.cpp_file
		endif
	endfunction
endif
