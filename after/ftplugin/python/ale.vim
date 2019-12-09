if !exists("g:py_sys_path")
  let g:py_sys_path=execute('py3 import sys;print("::".join(sys.path))')
  let g:py_sys_path = substitute(g:py_sys_path, '[\n\r ]*', '', '')
endif
let $PYTHONPATH = $PYTHONPATH.'::'.g:py_sys_path
let b:cnt= 1
while 1
  let b:path= findfile('__init__.py','.;',b:cnt)
  if b:path==#''
    break
  endif
  let $PYTHONPATH = $PYTHONPATH.'::'.fnamemodify(b:path, ':p:h')
  let b:cnt=b:cnt+1
endwhile

if has('win32')
  let $PYTHONPATH= substitute($PYTHONPATH, '/', '\','g')
  let $PYTHONPATH= substitute($PYTHONPATH, '::', ';','g')
else
  let $PYTHONPATH= substitute($PYTHONPATH, '::', ':','g')
endif

let $MYPYPATH = $PYTHONPATH

let b:ale_fixers= ['black','autopep8']
let b:ale_linters=  ['vulture','flake8', 'mypy', 'pylint','pyflakes','pyre']
let b:ale_python_pylint_options = '--disable=missing-docstring --disable=invalid-name --disable=too-few-public-methods --disable=broad-except --disable=bad-continuation --disable=wrong-import-position --disable=ungrouped-imports --disable=relative-beyond-top-level'
let b:ale_python_autopep8_options='--ignore E402 --aggressive --aggressive'
let b:ale_python_flake8_options='--ignore=E501,W504,W503,E402'
let b:ale_python_vulture_options='--min-confidence=90'
let b:ale_python_vulture_change_directory=0
