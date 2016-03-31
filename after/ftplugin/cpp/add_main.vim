" 自动生成main函数
if !exists("*CPP_open_relate_header")
	function! CPP_add_main()
		let main=["int main(int argc,char **argv)","{","\treturn 0;","}"]
		call append(0,main)
	endfunction
endif
