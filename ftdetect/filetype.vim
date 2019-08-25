" my filetype file
augroup filetypedetect
  au BufRead,BufNewFile *.thrift setfiletype thrift
  au BufRead,BufNewFile *.json.conf setfiletype json
  au BufRead,BufNewFile *.ps1 setfiletype ps1.powershell
  au BufRead,BufNewFile *.fish setfiletype fish
  au BufNewFile,BufRead [Dd]ockerfile,Dockerfile.* setfiletype dockerfile
augroup END
