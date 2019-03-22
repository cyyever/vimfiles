scripte utf-8

function! Bind_Key()
  	let is_header_file=0
	if (expand("%:p:e")=="h" || expand("%:p:e")=="hpp")
	  let is_header_file=1
	endif

	if (is_header_file==1) "c/c++头文件
		runtime ../after/ftplugin/cpp/open_relate_cpp_source.vim
		"功能键说明
		let g:Fkeys_msg="F2 加入重复包含指令 F3 增加作者注释 F4 打开相关文件 F12 帮助"
		map <F2> :call H_add_include_macro()<cr>
		map <F3> :call Comment_header()<cr>
		map <F4> :call Split_file_with_suffix(["C","c","cpp","cc","cxx"])<cr>
		map <F12> :echo g:Fkeys_msg<CR>
	elseif (&filetype=="c") "c源文件
		runtime ../after/ftplugin/cpp/open_relate_header.vim
		"功能键说明
		let g:Fkeys_msg="F2 增加main声明 F3 增加作者注释 F4 打开相关文件 F5 编译 F12 帮助"
		map <F2> :call C_add_main()<cr>
		map <F3> :call Comment_header()<cr>
		map <F4> :call Split_file_with_suffix(["h","hpp"])<cr>
		map <F12> :echo g:Fkeys_msg<cr>
	elseif (&filetype=="cpp")
		"功能键说明
		let g:Fkeys_msg="F2 增加main声明 F3 增加作者注释 F4 打开相关文件 F12 帮助"
		map <F2> :call CPP_add_main()<cr>
		map <F3> :call Comment_header()<cr>
		map <F4> :call Split_file_with_suffix(["h","hpp"])<cr>
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
