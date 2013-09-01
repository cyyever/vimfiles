scripte utf-8
let space='[\t \n\r]*'
let some_space='[\t \n\r]\+'

let func_header_maps=[  
			\ ['wait', 'sys/wait.h'],
			\]
let macro_header_maps=[  
			\ ['UINT_MAX', 'INT_MAX',  'limits.h'], 
			\ ['SIZE_MAX',  'stdint.h'], 
			\ ['SIGCHLD', 'SIGPIPE' , 'SIG_IGN', 'signal.h'], 
			\ ['PRIu64', 'uint64_t', 'uint32_t' , 'PRIi64', 'INT64_MIN', 'INT64_MAX', 'inttypes.h'], 
			\ ['size_t', 'NULL',  'stdlib.h'], 
			\ ['va_list',  'stdarg.h'], 
			\ ['errno',  'errno.h'], 
			\]

let struct_type_header_maps=[  
			\ ['sockaddr',  'sys/socket.h'], 
			\ ['sockaddr_un',  'sys/un.h'], 
			\ ['sockaddr_in',  'netinet/in.h'], 
			\]

function! C_complete_header(...)
	if(a:0 >1)
		" 补足函数头文件
		if a:1=="f"
			for i in range(1,a:0-1)
				for page_num in [2,3]
					" 通过man得知头文件名
					let man_cmd="set -o pipefail && ". "man ".page_num." ".a:000[i]." | col -b"
					echo man_cmd
					let man_output=split(system(man_cmd),'[\r\n]\+')
					if v:shell_error
						continue
					endif
					let func_idx=match(man_output,' '.a:000[i].'(')
					if func_idx != -1
						call remove(man_output,func_idx,-1)
						for j in range(len(man_output)-1,0,-1)
							let include_idx=match(man_output,'#include\s*<[^>]\+>',j) 
							if include_idx !=-1
								call C_insert_header(matchstr(man_output[include_idx],'[a-zA-Z_0-9/]\+\.h'))
								return
							endif
						endfor
					endif
					echo "解析 ".man_cmd." 出错"
					return
				endfor
				echo "man ".a:000[i]." 出错"
				return
			endfor	
		endif
	else
		let s:suffix=expand("%:p:e")

		if (s:suffix=="c")
			for func_header_map in reverse(copy(g:func_header_maps))
				for i in range(len(func_header_map)-1)
					let func_name=func_header_map[i]

		echo func_name
					if search('\<'.func_name.'\>'.g:space.'(',"wn") !=0
						if search('#'.g:space.'include'.g:some_space.'<'.escape(func_header_map[-1],'/'),"wn") ==0
							call C_insert_header(func_header_map[-1])
						endif
					endif
				endfor
			endfor
		endif
		if (s:suffix=="c") ||   (s:suffix=="h")
			for macro_header_map in reverse(copy(g:macro_header_maps))
				for i in range(len(macro_header_map)-1)
					let macro_name=macro_header_map[i]
					if search('\<'.macro_name.'\>',"wn") !=0
						if search('#'.g:space.'include'.g:some_space.'<'.escape(macro_header_map[-1],'/'),"wn") ==0
							call C_insert_header(macro_header_map[-1])
						endif
					endif
				endfor
			endfor


			for struct_type_header_map in reverse(copy(g:struct_type_header_maps))
				for i in range(len(struct_type_header_map)-1)
					let struct_name=struct_type_header_map[i]
					if search('struct'.g:some_space.struct_name.'\>',"wn") !=0
						if search('#'.g:space.'include'.g:some_space.'<'.escape(struct_type_header_map[-1],'/'),"wn") ==0
							call C_insert_header(struct_type_header_map[-1])
						endif
					endif
				endfor
			endfor
		endif
	endif
endfunction




function! C_insert_header(include)
	let save_cursor = getpos(".")
	call setpos('.',[0,1,1,0])
	let file_content=[]
	
	let include_begin='^\s*#\s*include\s\+<'
	let include_end='>\s*$'

	if(search(include_begin.a:include.include_end,"wn") !=0) " 是否已经包含？
		return
	endif

	let insert_pos=search(include_begin,"wn") " 找出第一个include
	if insert_pos ==0
		let insert_pos=search('^#\s*define\s\+'.toupper(expand("%:t:r"))."_H","wn") " 头文件头部
		if insert_pos !=0
			let insert_pos+=1
		else
			let insert_pos=search(' \*\t功能.*\n \*\/',"wn") " 文件注释尾部分
			if insert_pos !=0
				let insert_pos+=1
			endif
		endif
	endif

	let file_content+=["#include <".a:include.">"]
	call append(insert_pos,file_content)

	call setpos('.', save_cursor)
endfunction
