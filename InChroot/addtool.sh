cd /sources
#for files in gettext bison perl Python texinfo util-linux ; do
#	source /sources/pkginstall.sh 7 $files
#done

#source /sources/pkginstall.sh 7 texinfo

#Cleanup and removal

rm -rf /usr/share/{info,man,doc}/*
find /usr/{lib,libexec} -name \*.la -delete
#rm -rf /tools

