

./configure --prefix=/usr                   \
            --localstatedir=/var/lib/locate \
            --host=$lfstgt                 \
            --build=$(build-aux/config.guess)

make -j$(nproc)
make DESTDIR=$lfs install
