mkdir -v build
cd       build

../configure --prefix=$lfs/tools \
             --with-sysroot=$lfs \
             --target=$lfstgt   \
             --disable-nls       \
             --enable-gprofng=no \
             --disable-werror    \
             --enable-new-dtags  \
             --enable-default-hash-style=gnu

make -j$(nproc)
make install
