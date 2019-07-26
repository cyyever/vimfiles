let b:ale_fixers= ['black','autopep8']
let b:ale_linters=  ['vulture','flake8', 'mypy', 'pylint','pyflakes']
let b:ale_python_pylint_options = '--disable=missing-docstring --disable=invalid-name --disable=too-few-public-methods --disable=broad-except --disable=bad-continuation'
let b:ale_python_autopep8_options='--ignore E402 --aggressive --aggressive'
let b:ale_python_flake8_options='--ignore=E501 --ignore=W504'
let b:ale_python_vulture_options='--min-confidence=90'
