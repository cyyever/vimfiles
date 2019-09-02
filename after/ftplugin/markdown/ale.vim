scriptencoding utf-8
" 开启拼写检查
set spell

let b:ale_linters=  ['proselint','writegood','markdownlint','languagetool']

let b:languagetool_jar=$HOME.'/opt/LanguageTool-4.7-SNAPSHOT/languagetool-commandline.jar'
if filereadable(b:languagetool_jar)
 let b:ale_languagetool_commandline_jar=b:languagetool_jar
endif
