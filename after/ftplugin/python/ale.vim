let b:ale_fixers= ['black','autopep8']
let b:ale_linters=  ['vulture','flake8', 'mypy', 'pylint','pyflakes']
let b:ale_python_pylint_options = '--disable=missing-docstring'
let b:ale_python_autopep8_options='--ignore E402 --aggressive --aggressive'
