scripte utf-8
"功能键说明
let g:Fkeys_msg="F2 增加main声明 F3 增加作者注释 F4 打开相关文件 F5 编译 F6 代码补全 F12 帮助"
map <F2> :call C_add_main()<cr>
map <F3> :call Comment_header()<cr>
map <F4> :call C_open_relate_header()<cr>
map <F5> :call C_make()<cr>
map <F6> :call C_complete_header()<cr>
map <F12> :echo g:Fkeys_msg<cr>
