./configure --prefix=/usr --host=$lfstgt

make -j$(nproc)

make DESTDIR=$lfs install
