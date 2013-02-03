scripte utf-8
let space='[\t \n\r]*'
let some_space='[\t \n\r]\+'

let func_header_maps=[  
			\ ['malloc', 'calloc', 'free', 'stdlib.h'], 
			\ ['read', 'write', 'close', 'chdir', 'setsid', 'exit', 'unlink', 'getpid', 'unistd.h'],
			\ ['open', 'fcntl.h'],
			\ ['printf', 'sprintf', 'puts', 'stdio.h'],
			\ ['strerror', 'strlen', 'strcpy', 'strcat', 'strncpy' , 'memset' , 'string.h'],
			\ ['strerror', 'errno.h'],
			\ ['gettimeofday', 'sys/time.h'],
			\ ['time', 'time.h'],
			\ ['wait', 'getpid', 'sys/types.h'],
			\ ['wait', 'sys/wait.h'],
			\]
let macro_header_maps=[  
			\ ['UINT_MAX',  'limits.h'], 
			\ ['SIZE_MAX',  'stdint.h'], 
			\ ['SIGCHLD', 'SIGPIPE' , 'SIG_IGN', 'signal.h'], 
			\ ['PRIu64', 'uint64_t', 'inttypes.h'], 
			\ ['size_t', 'NULL',  'stdlib.h'], 
			\ ['va_list',  'stdarg.h'], 
			\]

let struct_type_header_maps=[  
			\ ['sockaddr',  'sys/socket.h'], 
			\ ['sockaddr_un',  'sys/un.h'], 
			\ ['sockaddr_in',  'netinet/in.h'], 
			\]

function! Add_code()
	let s:suffix=expand("%:p:e")

	if (s:suffix=="c")
		for func_header_map in reverse(copy(g:func_header_maps))
			for i in range(len(func_header_map)-1)
				let func_name=func_header_map[i]
				if search('\<'.func_name.'\>'.g:space.'(',"wn") !=0
					if search('#'.g:space.'include'.g:some_space.'<'.escape(func_header_map[-1],'/'),"wn") ==0
						call Insert_include(func_header_map[-1])
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
						call Insert_include(macro_header_map[-1])
					endif
				endif
			endfor
		endfor


		for struct_type_header_map in reverse(copy(g:struct_type_header_maps))
			for i in range(len(struct_type_header_map)-1)
				let struct_name=struct_type_header_map[i]
				if search('struct'.g:some_space.struct_name.'\>',"wn") !=0
					if search('#'.g:space.'include'.g:some_space.'<'.escape(struct_type_header_map[-1],'/'),"wn") ==0
						call Insert_include(struct_type_header_map[-1])
					endif
				endif
			endfor
		endfor
	endif
endfunction




function! Insert_include(include)
	let save_cursor = getpos(".")
	call setpos('.',[0,1,1,0])
	let file_content=[]

	let insert_pos=search('^\s*#'.g:space.'include\>',"wn") " 找出第一个include

	if insert_pos ==0
		let insert_pos=search('^#define '.toupper(expand("%:t:r"))."_H","wn") " 头文件头部
		if insert_pos !=0
			let insert_pos+=2
		endif
	endif


	if insert_pos ==0
		let insert_pos=search(' \*\t功能.*\n \*\/',"wn") " 文件注释尾部分
		if insert_pos !=0
			let insert_pos+=2
			let file_content+=[""]
		else
			let insert_pos=1
		endif
	endif

	let file_content+=["#include <".a:include.">"]
	let file_content+=getline(insert_pos,line('$'))
	let i=insert_pos
	for line in file_content
		call setline(i,line)
		let i=i+1
	endfor

	call setpos('.', save_cursor)
endfunction


