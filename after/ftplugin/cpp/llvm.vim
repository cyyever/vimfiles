if exists('llvm_dir')  && exists('llvm_version')
   finish
 endif
let g:llvm_dir=''
let g:llvm_version=''
if !has('win32')
  for llvm_version in range(10,9,-1)
    for path in ['/usr/lib/llvm-'.string(llvm_version),'/usr/local/llvm'.string(llvm_version).'0']
      if isdirectory(path)
        let g:llvm_dir=path
        let g:llvm_version=llvm_version
        break
      endif
    endfor
    if !empty(g:llvm_dir)
      break
    endif
  endfor
else
  for path in ['C:/Program Files/LLVM']
    if isdirectory(path)
      let g:llvm_dir=path
    endif
  endfor
endif
