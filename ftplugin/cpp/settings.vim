scripte utf-8
function! Change_Setting()
	let s:suffix=expand("%:p:e") "获取文件后缀
	"功能键说明
	let g:Fkeys_msg="F4 打开相关文件 F5 编译 F12 帮助"
	if (s:suffix=="h")
		map <F4> :call H_open_relate_cpp_source()<cr>
	else
		map <F4> :call CPP_open_relate_header()<cr>
	endif
	map <F5> :call CPP_make()<cr>
	map <F12> :echo g:Fkeys_msg<cr>
endfunction

if &filetype == "cpp"
	call Change_Setting()
endif
