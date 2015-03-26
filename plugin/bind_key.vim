scripte utf-8
function! Bind_Key()
	if (&filetype=="c" && expand("%:p:e")!="h")
		"功能键说明
		let g:Fkeys_msg="F2 增加main声明 F3 增加作者注释 F4 打开相关文件 F5 编译 F6 代码补全 F7 常用替换 F12 帮助"
		map <F2> :call C_add_main()<cr>
		map <F3> :call Comment_header()<cr>
		map <F4> :call C_open_relate_header()<cr>
		map <F5> :call C_make()<cr>
		map <F6> :call C_complete_header()<cr>
		map <F7> :call C_change_coding_style()<cr>
		map <F12> :echo g:Fkeys_msg<cr>
	elseif (&filetype=="c")
		"功能键说明
		let g:Fkeys_msg="F2 加入重复包含指令 F3 增加作者注释 F4 打开相关文件 F5 编译 F6 代码补全 F7 常用替换 F12 帮助"
		map <F2> :call H_add_include_macro()<cr>
		map <F3> :call Comment_header()<cr>
		map <F4> :call H_open_relate_c_source()<cr>
		map <F5> :call C_make()<cr>
		map <F6> :call C_complete_header()<cr>
		map <F7> :call C_change_coding_style()<cr>
		map <F12> :echo g:Fkeys_msg<CR>
	elseif (&filetype=="cpp")
		"功能键说明
		let g:Fkeys_msg="F4 打开相关文件 F5 编译 F12 帮助"
		map <F4> :call CPP_open_relate_header()<cr>
		map <F5> :call CPP_make()<cr>
		map <F12> :echo g:Fkeys_msg<CR>
	elseif (&filetype=="vim" || &filetype=="perl")
		"绑定功能键
		let g:Fkeys_msg="F2 增加头部注释 F12 帮助"
		map <F2> :call Comment_header()<cr>
		map <F12> :echo g:Fkeys_msg<CR>
	else
		map <F12> :echo "尚未绑定按键"<CR>
	endif
endfunction

au BufEnter * call Bind_Key() 
