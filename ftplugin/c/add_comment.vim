scripte utf-8
function! Add_Comment()
	let file_name=expand("%:t")
	let date=strftime("%Y-%m-%d")
	let file_content=['/*'," *\t程序名：".file_name," *\t作者：陈源源"," *\t日期：".date," *\t功能：",' */']
	let file_content+=getline(1,line('$'))
	let i=1 
	for line in file_content
		call setline(i,line)
		let i=i+1
	endfor
endfunction

