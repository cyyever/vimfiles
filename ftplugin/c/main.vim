" 自动生成main函数
function! Add_Main()
let main=["int main(int argc, char** argv)","{","}"]
let i=line('$')+1
if i==2
let i=1
endif
for line in main
call setline(i,line)
let i=i+1
endfor
endfunction

