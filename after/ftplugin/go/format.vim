let b:gofmt_path=exepath("gofmt")
if b:gofmt_path !=""
  setlocal formatprg=gofmt
  let b:file_path=expand("%:p")
  exec "autocmd BufWritePost ".b:file_path." execute('!".b:gofmt_path." -w ".b:file_path."')"
endif
