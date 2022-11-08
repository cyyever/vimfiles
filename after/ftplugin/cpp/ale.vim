let s:cur_dir=expand('<sfile>:p:h')
let s:customer_libs_dir=expand('~/opt')
exec 'source '.s:cur_dir.'/llvm.vim'
exec 'source '.s:cur_dir.'/gcc.vim'
" let b:ale_linters=  ['clang',  'clangtidy', 'cppcheck', 'gcc','pvsstudio']
let b:ale_linters=  [ 'cc', 'pvsstudio']

let s:common_cpp_options = '-std=c++2a -Wall -I'.s:customer_libs_dir.'/include'
let b:__clang_options= s:common_cpp_options.' -Wno-return-std-move-in-c++11 -isystem'.g:llvm_dir.'/include/c++ -isystem'.g:gcc_dir.'/include/c++ -Wno-unused-command-line-argument'
let b:ale_cpp_cc_executable= '<auto>'
let b:ale_cpp_cc_options = s:common_cpp_options
" if g:gcc_dir!=#''
"   let g:__gcc_exe=Executable_any([g:gcc_dir.'/bin/g++' ])
"   if g:__gcc_exe !=#''
"     let b:ale_cpp_cc_executable= g:__gcc_exe
"   endif
" elseif g:llvm_dir !=#''
"   let g:__clang_exe=Executable_any([g:llvm_dir.'/bin/clang++'])
"   if g:__clang_exe !=#''
"     let b:ale_cpp_cc_executable= g:__clang_exe
"     let b:ale_cpp_cc_options = g:__clang_options
"   endif
" endif

let b:ale_cpp_clangcheck_options='-extra-arg=\"'.b:__clang_options.'\"'
let b:ale_cpp_cppcheck_options=' --enable=warning,style,performance,portability,information'

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
