" 自动生成main函数
function! C_add_main()
	let main=["int main(int argc,char **argv)","{","\treturn 0;","}"]
	call append(0,main)
endfunction
