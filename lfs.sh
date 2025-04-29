#!/bin/bash

lfsdisk="/dev/sdb"
LFS_TGT=$(uname -m)-lfs-linux-gnu
export LFS="/mnt/lfs"
umask 0022

if [ ! -d $LFS ] ; then # here [ is a test command -d checks wether the directory exists or not. [ similar to test command
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

sudo mkdir -pv "$LFS"
sudo mount -v -t ext4 "$lfsdisk"2 $LFS


fi

sudo chown -v mlfs:mlfs $LFS
sudo chmod -v 755 $LFS
who
mkdir -pv $LFS/sources
mkdir -pv $LFS/{etc,var} 
mkdir -pv $LFS/usr/{bin,lib,sbin}
mkdir -pv $LFS/tools

if [ ! -h "$LFS/bin" ] || [ ! -h "$LFS/sbin" ] || [ ! -h "$LFS/lib" ]; then
	for i in bin lib sbin; do
		ln -sv usr/$i $LFS/$i
	done
fi

sudo chown -v root:root $LFS/sources/

case $(uname -m) in
	x86_64) mkdir -pv $LFS/lib64 ;;
esac

sudo chmod -v a+wt $LFS/sources

cp -rf *.sh ./lfspackages ./InChroot/ ./chapter*  "$LFS/sources"
cd "$LFS/sources" # current /mnt/lfs/sources


source ./download.sh

if [ $? -ne 0 ] ; then
	echo "Download failed. Exiting lfs script"
	exit 1
fi

#for folder in 5 6 ; do
#	for files in "$LFS"/sources/chapter"$folder"/* ; do
#		if [[ "$files" == *.sh ]] ; then
#			file="$(echo "$files" | awk -F'/' '{print $6}' | sed 's/\.sh//')"
#			source ./pkginstall.sh "$folder" "$file"
#		fi
#	done
#done

#TODO implement checking for installation

sudo chmod ugo+x ./chroot.sh
sudo chmod ugo+x ./InChroot/inchroot.sh

sudo ./chroot.sh $LFS

sudo chroot "$LFS" /usr/bin/env -i   \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin     \
    MAKEFLAGS="-j$(nproc)"      \
    TESTSUITEFLAGS="-j$(nproc)" \
    /bin/bash --login +h -c "/sources/InChroot/inchroot.sh"

#mountpoint -q $LFS/dev/shm && umount $LFS/dev/shm
#umount $LFS/dev/pts
#umount $LFS/{sys,proc,run,dev}
