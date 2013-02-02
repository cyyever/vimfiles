scripte utf-8
"常用的键映射
let s:subentrys=[ '执行下面全部键映射', {'替换行': 'map b pkddyy=='}]
function Temp_map()
	let l:index=Show_options("请选择以下键映射",s:subentrys)
	if(l:index==-1)
		return
	endif
	if(l:index !=0)
		let l:entry=s:subentrys[l:index]
		for l:key in keys(l:entry)
			exec l:entry[l:key]
		endfor
	else
		let l:subentrys=copy(s:subentrys)
		call remove(l:subentrys,0)
		for l:entry in l:subentrys
			for l:key in keys(l:entry)
				exec l:entry[l:key]
			endfor
		endfor
	endif
endfunction
