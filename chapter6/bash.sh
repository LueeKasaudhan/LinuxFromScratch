./configure --prefix=/usr                      \
            --build=$(sh support/config.guess) \
            --host=$lfstgt                    \
            --without-bash-malloc

make -j$(nproc)
make DESTDIR=$lfs install

ln -sv bash $lfs/bin/sh

