#!/bin/bash

lfsdisk="/dev/sdb"
lfstgt=$(uname -m)-lfs-linux-gnu
export lfs="/mnt/lfs"
umask 0022

if [ ! -d $lfs ] ; then # here [ is a test command -d checks wether the directory exists or not. [ similar to test command
sudo fdisk $lfsdisk << EOF
g
n
1

+300M
n
2


t
1
1
p
w
EOF
sudo mkfs.ext4 -L ROOT "$lfsdisk"2
sudo mkfs.ext2 -L BOOT "$lfsdisk"1

sudo mkdir -pv "$lfs"
sudo mount -v -t ext4 "$lfsdisk"2 $lfs


fi

sudo chown -v root:root $lfs
sudo chmod -v 755 $lfs
who
mkdir -pv $lfs/sources
mkdir -pv $lfs/{etc,var} 
mkdir -pv $lfs/usr/{bin,lib,sbin}
mkdir -pv $lfs/tools

if [ ! -h "$lfs/bin" ] || [ ! -h "$lfs/sbin" ] || [ ! -h "$lfs/lib" ]; then
	for i in bin lib sbin; do
		ln -sv usr/$i $lfs/$i
	done
fi

sudo chown -v root:root $lfs/sources/

case $(uname -m) in
	x86_64) mkdir -pv $lfs/lib64 ;;
esac

sudo chmod -v a+wt $lfs/sources

cp -rf *.sh ./lfspackages ./chapter*  "$lfs/sources"
cd "$lfs/sources" # current /mnt/lfs/sources


source ./download.sh

if [ $? -ne 0 ] ; then
	echo "Download failed. Exiting lfs script"
	exit 1
fi

source ./pkginstall.sh 6 binutils
exit 0

for folder in 5 6 ; do
	for files in "$lfs"/sources/chapter"$folder"/* ; do
		if [[ "$files" == *.sh ]] ; then
			file="$(echo "$files" | awk -F'/' '{print $6}' | sed 's/\.sh//')"
			source ./pkginstall.sh "$folder" "$file"
		fi
	done
done
