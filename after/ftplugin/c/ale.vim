let b:ale_linters=  ['clang', 'clangd', 'clangtidy', 'cppcheck', 'flawfinder' , 'gcc']
let s:clang_format_exe=Executable_any(['clang-format-devel','clang-format','clang-format-8'])
if s:clang_format_exe  !=#''
  let b:ale_c_clangformat_executable=s:clang_format_exe
endif
let b:ale_c_clangformat_options='-style=file'
let b:ale_fixers= ['clang-format','clangtidy']
