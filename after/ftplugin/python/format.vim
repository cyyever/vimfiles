let s:autopep8_path=exepath("autopep8")
if s:autopep8_path !=""
  exec "setlocal formatprg=".s:autopep8_path."\\ - "
  autocmd BufWritePre <buffer> normal mZgggqG'Zzz
endif
