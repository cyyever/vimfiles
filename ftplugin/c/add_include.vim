function! Add_Include()
	let file_content=["#ifndef ".toupper(expand("%:t:r"))."_H","#define ".toupper(expand("%:t:r"))."_H"]
	let file_content+=getline(1,line('$'))
	let file_content+=["#endif"]
	let i=1
	for line in file_content
		call setline(i,line)
		let i=i+1
	endfor
endfunction
