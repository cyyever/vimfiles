let b:autopep8_path=exepath("autopep8")
if b:autopep8_path !=""
  setlocal formatprg=autopep8\ -
  let b:file_path=expand("%:p")
  exec "autocmd BufWritePost ".b:file_path." execute('!".b:autopep8_path." -i ".b:file_path."')"
endif
