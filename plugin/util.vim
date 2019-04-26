scripte utf-8

"打开和当前窗口具有相同basename的指定后缀的文件
function! Split_file_with_suffix(suffix_list)
  let base_name=expand("%:p:r")
  for suffix in a:suffix_list
    let full_path=base_name.".".suffix
    if(filereadable(full_path) && !bufloaded(full_path))
      exe 'w'
      exe 'sp '.full_path
    endif
  endfor
endfunction

function! Executable_any(path_list)
  for path in a:path_list
    if executable(path) == 1
      return path
    endif
  endfor
  return ""
endfunction
