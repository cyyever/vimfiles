"把光标下的单词转大小写

function Switch_case()
" 找出光标下的token
let curline=getline('.')
let validletter="[a-zA-Z0-9_]" "token合法字符
let i=col('.') "当前列
let j=i
if match(curline[i-1],validletter)==-1
return []
endif
while match(curline[i-1],validletter)!=-1
let i=i-1
endwhile

while match(curline[j-1],validletter)!=-1
let j=j+1
endwhile
let j=j-1

if strpart(curline,i,j-i)[0] =~ '[a-z]' " 第一个字符是小写
call setline(line('.'),strpart(curline,0,i).toupper(strpart(curline,i,j-i)).strpart(curline,j))
else
call setline(line('.'),strpart(curline,0,i).tolower(strpart(curline,i,j-i)).strpart(curline,j))
endif
let curline=getline('.')
endfunction
