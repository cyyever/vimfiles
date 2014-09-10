tarball:
	tar -cf vim_scripts-`date +"%Y%m%d"`.tar `find  -name *.vim` makefile
gitpush:
	git push git@gitcafe.com:198767/vim_scripts.git
gitpull:
	git pull git@gitcafe.com:198767/vim_scripts.git
gen_key:
	ssh-keygen -t rsa -C "150614906@qq.com"
clean:
	rm -f `find  -name '*~'` vim_scripts*.tar
		
