./configure --prefix=/usr                     \
            --host=$lfstgt                   \
            --build=$(build-aux/config.guess) \
            --disable-static                  \
            --docdir=/usr/share/doc/xz-5.6.4

make -j$(nproc)

make DESTDIR=$lfs install

rm -v $lfs/usr/lib/liblzma.la
