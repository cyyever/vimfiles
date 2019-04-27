" my filetype file
if exists("did_load_filetypes")
  finish
endif
augroup filetypedetect
  au BufRead,BufNewFile *.thrift setfiletype thrift
  au BufRead,BufNewFile *.json.conf setfiletype json
  au BufRead,BufNewFile *.ps1 setfiletype ps1
  au BufNewFile,BufRead [Dd]ockerfile,Dockerfile.* setfiletype dockerfile
augroup END
