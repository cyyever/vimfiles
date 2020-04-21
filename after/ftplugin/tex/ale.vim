let b:ale_linters=  ['alex', 'chktex', 'lacheck',   'textlint','textidote']
let b:ale_fixers= ['latexindent']

let b:textidote_jar=$HOME.'/opt/textidote/textidote.jar'
if filereadable(b:textidote_jar)
  let b:ale_tex_textidote_executable='java'
  let b:ale_tex_textidote_options='-jar '.b:textidote_jar.' --no-color --output singleline '
  let b:ale_tex_textidote_check_lang='en'
endif
