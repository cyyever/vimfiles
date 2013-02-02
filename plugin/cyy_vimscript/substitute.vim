scripte utf-8
let s:subentrys=['执行下面全部替换']
let s:subentrys+=[{'消除highestdigit': '%s/highestdigit/msd/g'}]
let s:subentrys+=[{"处理lowstdigit" : '%s/lowestdigit/lsd/g'}]
let s:subentrys+=[{"处理digit": '%s/Digit/cell/g'}]
let s:subentrys+=[{"消除ln": '%s/lN/ln/g'}]
let s:subentrys+=[{"消除struct ln": '%s/struct ln/struct _ln/g'}]
let s:subentrys+=[{"消除struct digit": '%s/struct digit/struct _cell/g'}]
let s:subentrys+=[{"改变creat_ln": '%s/creat_ln/ln_creat/g'}]
let s:subentrys+=[{"改变 ->digit": '%s/->digit/->num/g'}]

function Substitute_tpl()
	let l:index=Show_options("请选择以下替换",s:subentrys)
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
