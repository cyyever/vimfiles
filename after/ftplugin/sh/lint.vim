function! CallShellLinters()
  let s:file_path=expand("%:p")
  " https://github.com/koalaman/shellcheck
  if executable("shellcheck") ==1
    execute("!shellcheck ".s:file_path)
  endif
endfunction

command! Lint call CallShellLinters()
