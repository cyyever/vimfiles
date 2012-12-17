#!/bin/sh
date=`date +"%Y%m%d"`
cd ..
tar -h -cf vim_scripts-${date}.tar --exclude=".svn*" --exclude=".netrwhist*" --exclude="*~"  .vim
