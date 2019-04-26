" https://github.com/jendrikseipp/vulture
let s:vulture_path=exepath("vulture")

function! CallPythonLinters()
  let s:file_path=expand("%:p")
  if s:vulture_path!=""
    execute("!".s:vulture_path." ".s:file_path)
  endif
endfunction

command! Lint call CallPythonLinters()
