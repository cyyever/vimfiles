scripte utf-8
"功能键说明
let g:Fkeys_msg="F3 增加作者注释 F12 帮助"
map <F3> :call Comment_header()<cr>
map <F12> :echo g:Fkeys_msg<cr>
