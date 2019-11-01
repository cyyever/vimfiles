let b:ale_linters=  ['clang', 'clangd', 'clangtidy', 'cppcheck', 'flawfinder' , 'gcc']
let b:ale_cpp_gcc_options = '-std=c++2a -Wall'
let b:ale_cpp_clang_options='-Wall -std=c++2a'
let b:ale_cpp_clangcheck_options='-extra-arg=\"'.b:ale_cpp_clang_options.'\"'

let s:clang_format_exe=Executable_any(['clang-format-devel','clang-format','clang-format-8'])
if s:clang_format_exe  !=#''
  let b:ale_c_clangformat_executable=s:clang_format_exe
endif
let b:ale_c_clangformat_options='-style=file -fallback-style=none'
let b:ale_cpp_clangtidy_extra_options='-std=c++2a'
let b:ale_fixers= ['clang-format','clangtidy']
