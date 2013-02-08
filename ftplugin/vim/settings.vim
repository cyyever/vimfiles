"
"	程序名：settings.vim
"	作者：陈源源
"	日期：2013-02-08
"	功能：vim相关全局设置
"
scripte utf-8
"绑定功能键
let g:Fkeys_msg="F2 增加头部注释 F12 帮助"
map <F2> :call Comment_header()<cr>
map <F12> :echo g:Fkeys_msg<CR>
