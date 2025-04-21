mkdir -v build
cd       build

../libstdc++-v3/configure           \
    --host=$lfstgt                 \
    --build=$(../config.guess)      \
    --prefix=/usr                   \
    --disable-multilib              \
    --disable-nls                   \
    --disable-libstdcxx-pch         \
    --with-gxx-include-dir=/tools/$lfstgt/include/c++/14.2.0

make -j$(nproc)
make DESTDIR=$lfs install

rm -v $lfs/usr/lib/lib{stdc++{,exp,fs},supc++}.la

