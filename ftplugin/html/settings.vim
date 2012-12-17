"功能键说明
let g:Fkeys_msg="F1 缩进 F2 打开相关文件 F4 修复颜色 F5 检测js错误 F9 替换value F12 帮助"
"缩进html这个很好用 因为以前的模板都很乱
""不过有个缺点就是js不会缩进
map <F1> :call Html_indent(" ")<CR>
map <F2> :call Split_src()<CR>
map <F3> :call Substitute_tpl()<CR>
"重新计算语法配色
map <F4> <esc>:syntax sync fromstart<cr>
"
""jsl是网上找的一个js代码静态检查工具，不是很好用，但是聊胜于无
"在/home/public/tools/jsl-0.3.0/src
map <F5> :! jsl -conf /home/public/tools/jsl_conf -process %<CR>
"
""把标签中 name="domainname" 旁边加上 value="@@DOMAINNAME@@"
map <F9> :s/name=\(["']\)\([^\1]*\)\1/name=\1\2\1 value=\1\@\@\U\2\@\@\1/g<CR>

map <F12> :echo g:Fkeys_msg<CR>
