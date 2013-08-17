scripte utf-8
let s:styles=['执行以下全部修改']
let s:styles+=[{'指针变量和星号结合': '%s/\(\<[a-zA-Z1-9_]\+\>\)\(\*\+\) /\1 \2/ge'}]

function C_change_coding_style()
	let l:index=Show_options("请选择以下选项",s:styles)
	if(l:index==-1)
		return
	endif

	if(l:index !=0)
		let l:entry=s:styles[l:index]
		for l:key in keys(l:entry)
			exec l:entry[l:key]
		endfor
	else
		let l:styles=copy(s:styles)
		call remove(l:styles,0)
		for l:entry in l:styles
			for l:key in keys(l:entry)
				exec l:entry[l:key]
			endfor
		endfor
	endif
endfunction
