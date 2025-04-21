./configure --prefix=/usr                     \
            --host=$lfstgt                   \
            --build=$(build-aux/config.guess) \
            --enable-install-program=hostname \
            --enable-no-install-program=kill,uptime

make -j$(nproc)
make DESTDIR=$lfs install

mv -v $lfs/usr/bin/chroot              $lfs/usr/sbin
mkdir -pv $lfs/usr/share/man/man8
mv -v $lfs/usr/share/man/man1/chroot.1 $lfs/usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/'                    $lfs/usr/share/man/man8/chroot.8
