scripte utf-8
"绑定功能键
let g:Fkeys_msg="F2 加入重复包含指令 F3 增加作者注释 F4 打开相关文件 F12 帮助"
map <F2> :call H_add_include_macro()<cr>
map <F3> :call Comment_header()<cr>
map <F4> :call H_open_relate_c_source()<cr>
map <F12> :echo g:Fkeys_msg<CR>
