if exists('gcc_dir')
  finish
endif
let g:gcc_dir=''

if isdirectory($HOME.'/opt/gcc')
  let g:gcc_dir=$HOME.'/opt/gcc'
  finish
endif

