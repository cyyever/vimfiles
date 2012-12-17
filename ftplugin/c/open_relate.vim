if !exists("*Open_relate") 
	function Open_relate()
		let s:suffix=expand("%:p:e") "获取文件后缀
		if (s:suffix=="c")
			let header_file=expand("%:p:s?\.c$?.h?")
			echo header_file
			if(!bufloaded(header_file))
				exe 'w'
				exe 'sp '.header_file
			endif
		elseif (s:suffix=="h")
			let c_file=expand("%:p:s?\.h$?.c?")
			echo c_file
			if(!bufloaded(c_file))
				exe 'w'
				exe 'sp '.c_file
			endif
		endif
	endfunction
endif
