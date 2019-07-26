let s:cnt= 1
while 1
  let s:path= findfile('__init__.py','.;',s:cnt)
  echo s:path
  if s:path==#''
    break
  endif
  let $PYTHONPATH = $PYTHONPATH.':'.fnamemodify(s:path, ':p:h')
  let s:cnt=s:cnt+1
endwhile
let $MYPYPATH = $PYTHONPATH

let b:ale_fixers= ['black','autopep8']
let b:ale_linters=  ['vulture','flake8', 'mypy', 'pylint','pyflakes']
let b:ale_python_pylint_options = '--disable=missing-docstring --disable=invalid-name --disable=too-few-public-methods --disable=broad-except --disable=bad-continuation --disable=wrong-import-position --disable=ungrouped-imports'
let b:ale_python_autopep8_options='--ignore E402 --aggressive --aggressive'
let b:ale_python_flake8_options='--ignore=E501,W504,W503,E402'
let b:ale_python_vulture_options='--min-confidence=90'
