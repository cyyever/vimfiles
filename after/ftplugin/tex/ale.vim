let b:ale_linters=  ['alex', 'chktex' , 'textlint','textidote']
let b:ale_fixers= ['latexindent','remove_trailing_lines','trim_whitespace']

let b:textidote_jar=$HOME.'/opt/textidote/textidote.jar'
let b:ale_tex_chktex_options='-n 1 -n 24 -n 44'
if filereadable(b:textidote_jar)
  let b:ale_tex_textidote_executable='java'
  let b:dict_file=&spellfile
  let b:ale_tex_textidote_check_lang='en'

  let b:removed_macros=['methodname','sysname']
  let b:ale_tex_textidote_options='-jar '.b:textidote_jar.' --no-color --output singleline --check en --read-all --ignore "sh:seclen,sh:nobreak,sh:008,sh:figmag"  --remove-macros "'.join(b:removed_macros, ',').'" --dict '.b:dict_file
endif

let b:ale_tex_latexindent_options="-y=\"defaultIndent:'  '\""
