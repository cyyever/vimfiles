tarball:
	date=`date +"%Y%m%d"`
	tar -cf vim_scripts-${date}.tar `find  -name *.vim`
gitpush:
	git push git@gitcafe.com:198767/vim_scripts.git
		
