if exists('gcc_dir')
  finish
endif
let g:gcc_dir=''

if isdirectory($HOME.'/opt/gcc/releases/gcc-10.2.0')
  let g:gcc_dir=$HOME.'/opt/gcc/releases/gcc-10.2.0'
  finish
endif
