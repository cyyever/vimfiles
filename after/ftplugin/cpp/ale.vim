let s:cur_dir=expand('<sfile>:p:h')
exec 'source '.s:cur_dir.'/llvm.vim'
exec 'source '.s:cur_dir.'/gcc.vim'
" let b:ale_linters=  ['clang',  'clangtidy', 'cppcheck', 'gcc','pvsstudio']
let b:ale_linters=  ['cppcheck', 'gcc','pvsstudio']
if g:gcc_dir!=#''
  let b:ale_cpp_gcc_executable = g:gcc_dir.'/bin/g++'
else
  let g:__gcc_exe=Executable_any(['gcc-10','gcc'])
  if g:__gcc_exe !=#''
    let b:ale_cpp_gcc_executable = g:__gcc_exe
  endif
endif

let b:ale_cpp_gcc_options = '-std=c++2a -Wall'
let b:ale_cpp_clang_executable=exepath( g:llvm_dir.'/bin/clang++')
let b:ale_cpp_clang_options='-Wall -std=c++2a -Wno-return-std-move-in-c++11 -isystem/opt/home/cyy/opt/include/c++'
let b:ale_cpp_clangcheck_options='-extra-arg=\"'.b:ale_cpp_clang_options.'\"'
let b:ale_cpp_cppcheck_options='--template=cppcheck1 --enable=warning,style,performance,portability,information'

let b:ale_fixers= ['clang-format','clangtidy']
if g:llvm_version !=#''
  let b:ale_c_clangformat_executable='clang-format-'.g:llvm_version
  let b:ale_cpp_clangtidy_executable ='clang-tidy-'.g:llvm_version
endif

let b:ale_c_clangformat_options='-style=file -fallback-style=none'

let b:ale_cpp_clangtidy_extra_options='-extra-arg=-std=c++2a'
let b:ale_cpp_clangtidy_fix_errors=0
let b:ale_cpp_clangtidy_checks =['*','-fuchsia-default-arguments*','-clang-analyzer-cplusplus.NewDeleteLeaks','-clang-diagnostic-ignored-optimization-argument','-readability-implicit-bool-conversion','-llvm-namespace-comment','-google-readability-namespace-comments','-cppcoreguidelines-owning-memory','-cert-err58-cpp','-fuchsia-statically-constructed-objects','-clang-diagnostic-gnu-zero-variadic-macro-arguments','-cppcoreguidelines-pro-bounds-pointer-arithmetic','-cppcoreguidelines-pro-type-vararg','-cppcoreguidelines-avoid-magic-numbers','-hicpp-vararg','-readability-magic-numbers','-cppcoreguidelines-pro-bounds-array-to-pointer-decay','-hicpp-no-array-decay','-modernize-use-trailing-return-type','-fuchsia-default-arguments-calls','-clang-diagnostic-ctad-maybe-unsupported','-google-build-using-namespace','-llvm-header-guard','-fuchsia-overloaded-operator','-modernize-use-nodiscard','-clang-diagnostic*','-misc-non-private-member-variables-in-classes','-cppcoreguidelines-non-private-member-variables-in-classes','-readability-redundant-access-specifiers','-llvmlibc*']

let b:ale_c_build_dir_names = ['aa','bb','a','b','build2','build']
let b:ale_c_parse_compile_commands=1
let b:ale_c_parse_makefile=1
