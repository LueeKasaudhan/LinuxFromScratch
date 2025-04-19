./configure --prefix=/usr                     \
            --host=$lfstgt                   \
            --build=$(build-aux/config.guess)

make -j$(nproc)

make DESTDIR=$lfs install
