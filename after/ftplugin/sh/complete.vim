let b:sh_file_path=expand("%:p")

"如果是新建的文件，那么写入#!
if getline(1)==""
  call setline(1,"#!/bin/bash")
endif

"设置可执行权限
let b:sh_new_fperm=substitute(getfperm(b:sh_file_path),'^\(..\).','\1x',"g")
exec "autocmd BufWritePost ".b:sh_file_path." call setfperm('".b:sh_file_path."','".b:sh_new_fperm."')"
