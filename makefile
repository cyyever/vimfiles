tarball:
	tar -cf vim_scripts-`date +"%Y%m%d"`.tar `find  -name *.vim` makefile
gitpush:
	git push git@gitcafe.com:198767/vim_scripts.git
clean:
	rm -f `find  -name '*~'` vim_scripts*.tar
		
