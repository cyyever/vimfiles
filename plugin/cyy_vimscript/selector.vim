scripte utf-8
function Show_options(waring,options)
	"显示提示信息
	let l:index=0
	let l:len=len(a:options)
	while(1)
		call Echo_options(l:index,a:waring,a:options)
		let c = getchar()
		if(c=="\<Up>")
			if(l:index>0)
				let l:index=(l:index-1)
			endif
		elseif(c=="\<Down>")
			if(l:index<l:len-1)
				let l:index=(l:index+1)
			endif
		elseif(c==27)
			let l:index=-1
			break
		elseif(c==13)
			break
		endif
		redraw!
	endwhile
	redraw!
	return l:index
endfunction

function Echo_options(index,waring,options)
	if(a:waring!="")
		echohl WarningMsg | echo a:waring | echohl None
	endif
	let l:maxnum=10 " 最多显示选项数
	let l:len=len(a:options)-1
	if(a:index < l:maxnum)
		let l:start_index=0
		let l:end_index=l:len
		if l:end_index>l:maxnum-1
			let l:end_index=l:maxnum-1
		endif
	else
		let l:start_index=a:index-l:maxnum+1
		let l:end_index=a:index
	endif
	for l:i in range(l:start_index,l:end_index)
		if(l:i == a:index)
			echohl Pmenu
		else
			echohl PmenuSel
		endif
		if(type(a:options[l:i]) ==type({})) "字典
			for a:key in keys(a:options[l:i])
				echo a:key." : ".a:options[l:i][a:key]
			endfor
		else
			echo a:options[l:i]
		endif
		echohl None
	endfor
	if(l:end_index < l:len)
		echohl WarningMsg | echo '-- More --' | echohl None
	endif
	echohl WarningMsg | echo '<Up> 上 <Down> 下 <Enter> 选中 <Esc> 取消' | echohl None
endfunction
