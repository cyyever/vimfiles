"本脚本 处理源文件的缩进
"目前可以处理 c文件 ec文件 vim脚本 js文件
"by 陈源源
function Vim_indent(indent)
let open_tokens=["function","function!","if","while","for"] "开始块
let close_tokens=["endfor","endwhile","endif","endfunction"] "结束块
let middle_tokens=['else','elseif'] "中间块
let reserve_lines={} " 保留行 不缩进
let indent_lines={} " 缩进行
let file_content=getline(1,line('$'))
let token_list=[] " 处理缩进的数据结构 格式为[[type,linenum]...]
" 缩进前处理一些特殊行
if Prepare_indent(file_content,reserve_lines,indent_lines) !=0
return
endif

for i in sort(keys(indent_lines),"Sort_num")
for tokentype in Get_token(indent_lines[i],open_tokens,middle_tokens,close_tokens)
call add(token_list,[tokentype,i])
endfor
let indent_lines[i]=""
endfor

let prevtype=token_list[0][0]
let prevlinenum=token_list[0][1]
let indent_lines[prevlinenum]=""
for i in range(1,len(token_list)-1)
let type=token_list[i][0]
let linenum=token_list[i][1]

if(linenum==prevlinenum) " 同一行 缩进已经设置了
let prevtype=type
let prevlinenum=linenum
continue
endif
if prevtype==0 || prevtype==1 " 上一行是开始块或中间块
for j in range(prevlinenum+1,linenum)
let indent_lines[j]=indent_lines[prevlinenum].a:indent
endfor
if type !=0
let indent_lines[linenum]=indent_lines[prevlinenum]
endif
else " 上一行是结束块
for j in range(prevlinenum+1,linenum)
let indent_lines[j]=indent_lines[prevlinenum]
endfor
if type!=0 " 本行是中间块或结束块
let indent_lines[linenum]=substitute(indent_lines[prevlinenum],a:indent,"","")
endif
endif
let prevtype=type
let prevlinenum=linenum
endfor
"缩进
let total_lines=Do_indent(file_content,reserve_lines,indent_lines)
for i in keys(total_lines)
call setline(i+1,total_lines[i])
endfor

endfunction


function C_indent(indent,startindent,startline,endline)
let open_tokens=["if","while","for"] "开始块
let middle_tokens=['else\s\+if','else'] "中间块
let reserve_lines={} " 保留行 不缩进
let indent_lines={} " 缩进行
let indent_lines2=[] " 缩进行
let file_content=getline(a:startline,a:endline)
" 缩进前处理一些特殊行
if Prepare_indent(file_content,reserve_lines,indent_lines) !=0
return
endif

let j=0
for i in sort(keys(indent_lines),"Sort_num")
call add(indent_lines2,substitute(indent_lines[i],'\(^\s\+\)\|\(\s\+$\)',"","g"))
let indent_lines[i]=[j,""]
let j+=1
endfor



let prevblank=""
let notindent=0 " 下一行是否收缩
for i in (range(1,len(indent_lines2)-1))
let prevline=indent_lines2[i-1]
let curline=indent_lines2[i]
if curline[0]=='}' " 本行就是} 收缩
"找出匹配的{
let stack=1
let flag=0
for j in range(i-1,1,-1)
let prevline=indent_lines2[j]
for k in range(len(prevline)-1,0,-1)
if prevline[k]=='}'
let stack+=1
elseif prevline[k]=='{'
let stack-=1
if(stack==0)
for k in sort(keys(indent_lines),"Sort_num")
if indent_lines[k][0]==j
let curblank=indent_lines[k][1]
let flag=1
break
endif
endfor
break
endif
endif
endfor
if flag==1
break
endif
endfor
if(stack!=0)
for k in sort(keys(indent_lines),"Sort_num")
if indent_lines[k][0]==i
echo "第".k+1."行的}找不到匹配的{ 缩进失败"
return
endif
endfor
endif
let notindent=0
elseif notindent==1
let curblank=substitute(prevblank,a:indent,"","")
let notindent=0
elseif prevline =~ '{$' " 上一行是{
"本行缩进一个tab
let curblank=prevblank.a:indent
elseif Token_match(prevline,open_tokens+middle_tokens)==1 " 上一行是 块开始标签
if curline =~ '{$' " 本行就是{ 无缩进
let curblank=prevblank
else "本行是普通语句
let curblank=prevblank.a:indent
let notindent=1 "下一行需要缩回
endif
elseif prevline[0]=='}' " 上一行是}
let curblank=prevblank
else " 上一行是普通语句
if Token_match(curline,middle_tokens) " 本行就是 中间块 收缩
if(match(prevline,'^\s*}') !=-1) " 上一行是}
let curblank=prevblank
else
let curblank=substitute(prevblank,a:indent,"","")
endif
else "本行也是普通语句
let curblank=prevblank
endif
endif
let curline=substitute(curline,'^\s*',curblank,"")
for k in sort(keys(indent_lines),"Sort_num")
if indent_lines[k][0]==i
let indent_lines[k][1]=curblank
let prevblank=curblank
break
endif
endfor
endfor
for k in keys(indent_lines)
let indent_lines[k]=a:startindent.indent_lines[k][1]
endfor
"缩进
"
call Do_indent(file_content,reserve_lines,indent_lines)
let total_lines=Do_indent(file_content,reserve_lines,indent_lines)
for i in keys(total_lines)
call setline(i+a:startline,total_lines[i])
endfor

endfunction



""获取line中的token
function Get_token(line,open_tokens,middle_tokens,close_tokens)
let suffix=expand("%:p:e") "获取文件后缀
if(suffix=="vim")
let tokens= split(substitute(a:line,'\([{}()]\)',' \1 ',"g"),' ')
let token_list=[]
let token=substitute(tokens[0],'\s*',"","g") " 去空格
if index(a:open_tokens,token) >=0
let token_list+=[0]
elseif index(a:middle_tokens,token) >=0
let token_list+=[1]
elseif index(a:close_tokens,token) >=0
let token_list+=[2]
endif
endif
return token_list
endfunction

"如果line的第一个token在token_list里面 返回1 否则返回 0
function Token_match(line,token_list)
for token in a:token_list
if(match(a:line,'^\s*'.token.'\>') !=-1)
return 1
endif
endfor
return 0
endfunction

""缩进之前先剔除一些行 比如空格 注释之类的
function Prepare_indent(file_content,reserve_lines,indent_lines)
let suffix=expand("%:p:e") "获取文件后缀
if(suffix=="htm" || suffix=="html" ) " html文件
let section_list=[]
for i in range(len(a:file_content))
if has_key(a:reserve_lines,i)
continue
endif
let line=a:file_content[i]
if match(line,'^\s*$') !=-1 " 空行
let a:reserve_lines[i]=-1
elseif line =~ '^\s*<!-- @@[^@]\+@@ -->\s*$'
let line=substitute(line,'\(^\s\+\)\|\(\s\+$\)',"","g") " 去前后空格
let flag=0
for j in range(len(section_list)-1,0,-1)
let section=section_list[j]
if section[1]==line
let a:reserve_lines[i]=section[0] " 节点互相索引
let a:reserve_lines[section[0]]=i " 节点互相索引
let flag=1
call remove(section_list,j)
break
endif
endfor
if flag==0
call add(section_list,[i,line])
endif
elseif match(line,'^\s*<!.*') !=-1 " html注释 或者dtd语句等
let a:reserve_lines[i]=-2
else
let a:indent_lines[i]=line
endif
endfor

for j in range(len(section_list)-1,0,-1)
echo "line ".j.": can not find match section for ".section_list[j][1]
return 1
endfor
elseif suffix=="c" || suffix=="ec" " c文件
let commentline=-1
for i in range(len(a:file_content))
if has_key(a:reserve_lines,i)
continue
endif
let line=a:file_content[i]
if match(line,'^\s*$') !=-1 " 空行
let a:reserve_lines[i]=-1
elseif line =~ '^\s*\/\*' " 处理/*注释
if commentline==-1
let commentline=i
else
echo "line ".commentline.": can not find match comment"
return 1
endif
elseif line =~ '\*\/\s*$' " 处理*/注释
if commentline==-1
echo "line ".i.": can not find match comment"
return 1
else
" 互相索引
let a:reserve_lines[i]=commentline
let a:reserve_lines[commentline]=i
let commentline=-1
endif
elseif match(line,'^\s*\/\/') !=-1 " //注释
 let a:reserve_lines[i]=-2
 elseif commentline ==-1
 let a:indent_lines[i]=line
 endif
 endfor
 elseif suffix=="vim" " vim脚本
for i in range(len(a:file_content))
if has_key(a:reserve_lines,i)
continue
endif
let line=a:file_content[i]
if match(line,'^\s*$') !=-1 " 空行
 let a:reserve_lines[i]=-1
 elseif match(line,'^\s*"') !=-1 " //注释
 let a:reserve_lines[i]=-2
 else
 let a:indent_lines[i]=line
 endif
 endfor
 endif

 return 0
 endfunction


 function Reverse_num(i,j)
 return a:j*1-a:i*1
 endfunction
 function Sort_num(i,j)
 return a:i*1-a:j*1
 endfunction

 "实施实际的缩进
function Do_indent(file_content,reserve_lines,indent_lines)
let suffix=expand("%:p:e") "获取文件后缀
 let total_lines={}
 for i in keys(a:indent_lines)
 let total_lines[i]=substitute(a:file_content[i],'^\s*',a:indent_lines[i],"")
 endfor

 for i in sort(keys(a:reserve_lines),"Reverse_num")
 if a:reserve_lines[i] == -1 || a:reserve_lines[i] ==-2
 if has_key(total_lines,i+1)
 let indent=matchlist(total_lines[i+1],'^\s*')[0]
 let total_lines[i]=substitute(a:file_content[i],'^\s*',indent,"")
 else
 let total_lines[i]=substitute(a:file_content[i],'^\s*',"","")
 endif
 else
 if(suffix=="htm" || suffix=="html" ) " html文件
if a:reserve_lines[i] > i " 开节点
 let indent=matchlist(total_lines[i+1],'^\s*')[0]
 let j=a:reserve_lines[i]
 let total_lines[i]=substitute(a:file_content[i],'^\s*',indent,"")
 let total_lines[j]=substitute(a:file_content[j],'^\s*',indent,"")
 endif
 elseif suffix=="c" || suffix=="ec"
 if a:reserve_lines[i] < i " */注释
let indent=matchlist(total_lines[i+1],'^\s*')[0]
let j=a:reserve_lines[i]
let total_lines[j]=substitute(a:file_content[j],'^\s*',indent,"") " 缩进 /*
 let total_lines[i]=substitute(a:file_content[i],'^\s*',indent,"") " 缩进 */
 " 缩进中间的注释
if i!=j
let previndent=Get_indent(a:file_content[j])
for k in range(j+1,i-1)
let total_lines[k]=substitute(a:file_content[k],previndent,indent,"")
endfor
endif
endif
endif
endif
endfor
return total_lines
endfunction

" 获取line的缩进
 function Get_indent(line)
 for i in range(len(a:line))
 if a:line[i] !=" " && a:line[i] != "\t"
 break
 endif
 endfor
 return strpart(a:line,0,i)
 endfunction


 "缩进html文件
function Html_indent(indent)
let reserve_lines={} " 保留行
 let indent_lines={} " 缩进行
let tag_list=[] " 处理缩进的数据结构 格式为[[tag,type,linenum]...]
 let file_content=getline(1,line('$'))

 " 缩进前处理一些特殊行
if Prepare_indent(file_content,reserve_lines,indent_lines) !=0
return
endif
for i in range(line('$'))
if has_key(indent_lines,i)
for tag in Get_htmltag(indent_lines[i],i)
call add(tag_list,tag)
endfor
let indent_lines[i]=""
endif
endfor
"补足标签
 let i=0
 while i < len(tag_list)
 if(tag_list[i][1]==1) " close tag
let j=i-1
while(j >=0)
if(tag_list[j][1]==0) " open tag
 if(tag_list[j][0]==tag_list[i][0]) "找到匹配的close tag
type变成保存彼此的索引
let tag_list[i][1]=j
let tag_list[j][1]=i
break
else
let tag_list[j][1]=j " 自包含tag
 endif
 endif
 let j -= 1
 endwhile
 if(j<0)
 echo "line ".(tag_list[i][2]+1).": can not find match tag for
</".tag_list[i][0].">"
 return
 endif
 endif
 let i +=1
 endwhile
 let i=1
 while i < len(tag_list)
 let num1=tag_list[i][2]
 let num2=tag_list[i-1][2]
 if(num1==num2) " 同一行的标签 缩进不变
let i+=1
continue
endif
if tag_list[i][1] < i " close tag
 let num3=tag_list[tag_list[i][1]][2]
 let indent_lines[num1]=indent_lines[num3]
 elseif tag_list[i-1][1] > i-1 " open tag
let indent_lines[num1]=indent_lines[num2].a:indent
else
let indent_lines[num1]=indent_lines[num2]
endif
let i+=1
endwhile
"缩进
 let total_lines=Do_indent(file_content,reserve_lines,indent_lines)
 for i in keys(total_lines)
 call setline(i+1,total_lines[i])
 endfor
 endfunction

 "获取line中的htmltag
"返回列表，形式为[[tag1,type1],[tag2,type2]...] type 0-开标签 1-闭标签
 function Get_htmltag(line,linenum)
 let a=-1
 let b=-1
 let tag=[]
 for i in range(strlen(a:line))
 if(a:line[i]=="<")
 if(match(a:line[i+1],'[a-zA-Z]') !=-1)
 let a=i+1
 elseif(a:line[i+1]=='/')
 let b=i+2
 endif
 elseif(a:line[i]=='>' || match(a:line[i],'\s') !=-1)
 if(a!=-1)
 call add(tag,[tolower(strpart(a:line,a,i-a)),0,a:linenum])
 let a=-1
 elseif(b!=-1)
 call add(tag,[tolower(strpart(a:line,b,i-b)),1,a:linenum])
 let b=-1
 endif
 endif
 endfor
 return tag
 endfunction
