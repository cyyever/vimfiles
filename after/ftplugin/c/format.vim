let s:clang_format_exe=Executable_any("clang-format","clang-format-devel")
if s:clang_format_exe !=""
  let &formatprg=s:clang_format_exe
  autocmd BufWritePre <buffer> normal mZgggqG'Zzz
endif
