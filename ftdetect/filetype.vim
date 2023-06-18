" my filetype file
augroup filetypedetect
  au BufRead,BufNewFile *.thrift setfiletype thrift
  au BufRead,BufNewFile *.json.conf setfiletype json
  au BufRead,BufNewFile Vagrantfile setfiletype ruby
  au BufNewFile,BufRead [Dd]ockerfile,Dockerfile.* setfiletype dockerfile
augroup END
