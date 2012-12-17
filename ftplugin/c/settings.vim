function! Change_Setting()
	let s:suffix=expand("%:p:e") "获取文件后缀
	if (s:suffix=="c")
		"功能键说明
		let g:Fkeys_msg="F2 增加main声明 F3 增加作者注释 F4 打开相关文件 F5 编译 F6 代码补全 F12 帮助"
		map <F2> :call Add_Main()<cr>
		map <F3> :call Add_Comment()<cr>
		map <F4> :call Open_relate()<cr>
		map <F5> :call Make()<cr>
		map <F6> :call Add_code()<cr>
		map <F12> :echo g:Fkeys_msg<cr>
	elseif (s:suffix=="h")
		"功能键说明
		let g:Fkeys_msg="F2 加入重复包含指令 F3 增加作者注释 F4 打开相关文件 F5 编译 F12 帮助"
		map <F2> :call Add_Include()<cr>
		map <F3> :call Add_Comment()<cr>
		map <F4> :call Open_relate()<cr>
		map <F5> :call Make()<cr>
		map <F6> :call Add_code()<cr>
		map <F12> :echo g:Fkeys_msg<CR>
	else
		map <F12> :echo "尚未绑定按键"<CR>
	endif
endfunction

setlocal cindent
autocmd BufEnter *.c,*.h  call Change_Setting()
