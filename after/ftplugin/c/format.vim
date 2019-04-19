let b:clang_format_path=exepath("clang-format")
if b:clang_format_path !=""
  setlocal formatprg=clang-format
  let b:file_path=expand("%:p")
  exec "autocmd BufWritePost ".b:file_path." execute('!".b:clang_format_path." -i ".b:file_path."')"
endif
