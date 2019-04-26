let s:vulture_path=exepath("vulture")

function! CallPythonLinters()
  let s:file_path=expand("%:p")
  if s:vulture_path!=""
    execute("!clear ; ".s:vulture_path." ".s:file_path)
  endif
endfunction

command CallLinters call CallPythonLinters()
