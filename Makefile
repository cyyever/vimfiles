tarball:
	tar -cf vim_scripts-`date +"%Y%m%d"`.tar `find  -name *.vim` makefile
push:
	git push git@gitcafe.com:cyy_ever/vim_scripts.git master
pull:
	git pull git@gitcafe.com:cyy_ever/vim_scripts.git master
clean:
	rm -f `find  -name '*~'` vim_scripts*.tar
		
