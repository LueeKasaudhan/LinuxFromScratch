./configure --prefix=/usr                      \
            --build=$(sh support/config.guess) \
            --host=$LFS_TGT                    \
            --without-bash-malloc              \
            bash_cv_strtold_broken=no
make -j$(nproc)
make DESTDIR=$LFS install
ln -sv bash $LFS/bin/sh