newuser="mlfs"
newgroup="mlfs"
user_home="/home/$newuser"
scriptfile="/home/luee/Project/GitProjects/LinuxFromScratch/lfs.sh"

if ! cat "/etc/passwd" | grep "$newuser" ; then
	echo "Creating new group named $newgroup"
	sudo groupadd $newgroup
	echo "Creating new user named $newuser"
	sudo useradd -s /bin/bash -g $newgroup -m -k /dev/null $newuesr
	echo "Enter the password for $newuser"
	sudo passwd $newuser
	sudo chown -v $newuser $LFS/{usr{,/*},var,etc,tools}
	case $(uname -m) in
	  x86_64) chown -v $newuser $LFS/lib64 ;;
	esac
fi

sudo tee /home/$newuser/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

sudo tee /home/$newuser/.bashrc << "EOF"
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE
EOF

