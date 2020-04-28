let b:ale_linters=  ['alex', 'chktex' , 'textlint','textidote']
let b:ale_fixers= ['latexindent']

let b:textidote_jar=$HOME.'/opt/textidote/textidote.jar'
if filereadable(b:textidote_jar)
  let b:ale_tex_textidote_executable='java'
  let b:dict_file=&spellfile
  let b:ale_tex_textidote_check_lang='en'

  let b:removed_macros=['derivative','approxvar']
  let b:ale_tex_textidote_options='-jar '.b:textidote_jar.' --no-color --output singleline --remove-macros '.join(b:removed_macros, ',').' --dict '.b:dict_file
endif
