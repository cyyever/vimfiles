if exists('llvm_dir')  && exists('llvm_version')
  finish
endif
let g:llvm_dir=''
let g:llvm_version=''

if isdirectory($HOME.'/opt/llvm')
  let g:llvm_dir=$HOME.'/opt/llvm'
  let g:llvm_version=''
  finish
endif

if !has('win32')
  for _llvm_version in range(10,9,-1)
    for path in ['/usr/lib/llvm-'.string(_llvm_version),'/usr/local/llvm'.string(_llvm_version).'0']
      if isdirectory(path)
        let g:llvm_dir=path
        let g:llvm_version=_llvm_version
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
      let g:llvm_version=''
    endif
  endfor
endif
