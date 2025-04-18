sed '6031s/$add_dir//' -i ltmain.sh


mkdir -v build
cd       build


../configure                   \
    --prefix=/usr              \
    --build=$(../config.guess) \
    --host=$lfstgt            \
    --disable-nls              \
    --enable-shared            \
    --enable-gprofng=no        \
    --disable-werror           \
    --enable-64-bit-bfd        \
    --enable-new-dtags         \
    --enable-default-hash-style=gnu


make -j$(nproc)

make DESTDIR=$lfs install


rm -v $lfs/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes,sframe}.{a,la}
