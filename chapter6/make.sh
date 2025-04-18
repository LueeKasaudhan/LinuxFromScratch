./configure --prefix=/usr   \
            --without-guile \
            --host=$lfstgt \
            --build=$(build-aux/config.guess)


make -j$(nproc)

make DESTDIR=$lfs install
