let b:ale_cpp_gcc_options = '-std=c++2a -Wall'
let b:ale_cpp_clang_options='-Wall -std=c++2a'

let s:clang_format_exe=Executable_any(['clang-format','clang-format-devel','clang-format-8'])
if s:clang_format_exe  !=#''
  let b:ale_c_clangformat_executable=s:clang_format_exe
endif
let b:ale_c_clangformat_options='-style=file -assume-filename="'.expand('%:p').'" '
let b:ale_fixers= ['clang-format']
