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
	sudo chown -v $newuser $lfs/{usr{,/*},var,etc,tools}
	case $(uname -m) in
	  x86_64) chown -v $newuser $lfs/lib64 ;;
	esac
fi

sudo tee /home/$newuser/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

sudo tee /home/$newuser/.bashrc << "EOF"
set +h
umask 022
lfs=/mnt/lfs
LC_ALL=POSIX
lfstgt=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$lfs/tools/bin:$PATH
CONFIG_SITE=$lfs/usr/share/config.site
export lfs LC_ALL lfstgt PATH CONFIG_SITE
EOF

