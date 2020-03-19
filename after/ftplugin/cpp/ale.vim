let b:ale_linters=  ['clang',  'clangtidy', 'cppcheck', 'flawfinder' , 'gcc','pvsstudio']
let b:ale_cpp_gcc_options = '-std=c++2a -Wall'
let b:ale_cpp_clang_options='-Wall -std=c++2a'
let b:ale_cpp_clangcheck_options='-extra-arg=\"'.b:ale_cpp_clang_options.'\"'
let b:ale_cpp_cppcheck_options='--template=cppcheck1 --enable=warning,style,performance,portability,information'

let s:clang_format_exe=Executable_any(['clang-format-devel','clang-format','clang-format-8'])
if s:clang_format_exe  !=#''
  let b:ale_c_clangformat_executable=s:clang_format_exe
endif
let b:ale_c_clangformat_options='-style=file -fallback-style=none'

let b:ale_fixers= ['clang-format','clangtidy']
let b:ale_cpp_clangtidy_extra_options='-extra-arg=-std=c++2a'
let b:ale_cpp_clangtidy_fix_errors=0
let b:ale_cpp_clangtidy_checks =['*','-fuchsia-default-arguments*','-clang-analyzer-cplusplus.NewDeleteLeaks','-clang-diagnostic-ignored-optimization-argument','-readability-implicit-bool-conversion','-llvm-namespace-comment','-google-readability-namespace-comments','-cppcoreguidelines-owning-memory','-cert-err58-cpp','-fuchsia-statically-constructed-objects','-clang-diagnostic-gnu-zero-variadic-macro-arguments','-cppcoreguidelines-pro-bounds-pointer-arithmetic','-cppcoreguidelines-pro-type-vararg','-cppcoreguidelines-avoid-magic-numbers','-hicpp-vararg','-readability-magic-numbers','-cppcoreguidelines-pro-bounds-array-to-pointer-decay','-hicpp-no-array-decay','-modernize-use-trailing-return-type','-fuchsia-default-arguments-calls','-clang-diagnostic-ctad-maybe-unsupported','-google-build-using-namespace','-llvm-header-guard','-fuchsia-overloaded-operator','-modernize-use-nodiscard']

let b:ale_c_build_dir_names = ['aa','bb','a','b','build2','build']
let b:ale_c_parse_compile_commands=1
let b:ale_c_parse_makefile=1
