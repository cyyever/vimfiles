let b:ale_linters=  ['clang', 'clangd', 'clangtidy',  'flawfinder' , 'gcc','pvsstudio']
let b:ale_c_gcc_options = '-std=c11 -Wall -Wextra -fmax-errors=1 -fopenmp'
let b:ale_c_clang_options = '-std=c11 -Weverything  -Wno-padded -Wno-strict-prototypes -Wno-double-promotion -ferror-limit=1 -Wno-sign-conversion -Wno-missing-prototypes -Wno-implicit-float-conversion -Wno-float-conversion -fopenmp'
let b:ale_c_flawfinder_minlevel=4
let s:clang_format_exe=Executable_any(['clang-format-devel','clang-format','clang-format-8'])
if s:clang_format_exe  !=#''
  let b:ale_c_clangformat_executable=s:clang_format_exe
endif
let b:ale_c_clangformat_options='-style=file -fallback-style=none'
let b:ale_fixers= ['clang-format','clangtidy']
let b:ale_c_build_dir_names = ['aa','bb','a','b','build2','build']
let b:ale_c_clangtidy_fix_errors=0
let b:ale_c_parse_compile_commands=1
let b:ale_c_parse_makefile=1
