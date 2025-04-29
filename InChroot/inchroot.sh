echo "You've entered lfs's chroot environment"

mkdir -pv /{boot,home,mnt,opt,srv}

mkdir -pv /etc/{opt,sysconfig}
mkdir -pv /lib/firmware
mkdir -pv /media/{floppy,cdrom}
mkdir -pv /usr/{,local/}{include,src}
mkdir -pv /usr/lib/locale
mkdir -pv /usr/local/{bin,lib,sbin}
mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man}
mkdir -pv /usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -pv /usr/{,local/}share/man/man{1..8}
mkdir -pv /var/{cache,local,log,mail,opt,spool}
mkdir -pv /var/lib/{color,misc,locate}

ln -sfv /run /var/run
ln -sfv /run/lock /var/lock

install -dv -m 0750 /root
install -dv -m 1777 /tmp /var/tmp

ln -sv /proc/self/mounts /etc/mtab

# creating a basic /etc/hosts file
cat > /etc/hosts << EOF
127.0.0.1  localhost $(hostname)
::1        localhost
EOF

#The Linux Standard Base only recommends that the group root with a Group ID (GID) of 0, a group bin with a GID of 1 be present.
#The GID of 5 is widely used for the tty group
#and the number 5 is also used in /etc/fstab for the devpts filesystem
#all the other group name and gid can be chosen feely. by sys admin
#The ID 65534 is used by the kernel for NFS and separate user namespaces for unmapped users and groups
#those exist on the NFS server or the parent user namespace, but "do not exist" on the local machine or in the separate namespace
# assign nobody and nogroup to avoid an unnamed ID

#creating necessary users and groups
#users in /etc/passwd
cat > /etc/passwd << "EOF"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/usr/bin/false
daemon:x:6:6:Daemon User:/dev/null:/usr/bin/false
messagebus:x:18:18:D-Bus Message Daemon User:/run/dbus:/usr/bin/false
uuidd:x:80:80:UUID Generation Daemon User:/dev/null:/usr/bin/false
nobody:x:65534:65534:Unprivileged User:/dev/null:/usr/bin/false
EOF

#groups in /etc/group
cat > /etc/group << "EOF"
root:x:0:
bin:x:1:daemon
sys:x:2:
kmem:x:3:
tape:x:4:
tty:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
cdrom:x:15:
adm:x:16:
messagebus:x:18:
input:x:24:
mail:x:34:
kvm:x:61:
uuidd:x:80:
wheel:x:97:
users:x:999:
nogroup:x:65534:
EOF

localedef -i C -f UTF-8 C.UTF-8

#temporary user added and deleted after the end of the chapter.

echo "tester:x:101:101::/home/tester:/bin/bash" >> /etc/passwd
echo "tester:x:101:" >> /etc/group
install -o tester -d /home/tester
#creating the log files for agetty , login and init programs

touch /var/log/{btmp,lastlog,faillog,wtmp}
chgrp -v utmp /var/log/lastlog
chmod -v 664  /var/log/lastlog
chmod -v 600  /var/log/btmp

#wtmp --> all logins and logouts
#btmp --> bad login attempts
#faillog --> failed login attempts
#lastlog --> last logged in user
#/run/utmp --> records of user which are currently logged in
#all of them use 32 bit time stamps

chmod ugo+x /sources/InChroot/addtool.sh
exec /usr/bin/bash --login



