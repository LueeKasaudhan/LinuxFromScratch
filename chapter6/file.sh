mkdir build
pushd build
  ../configure --disable-bzlib      \
               --disable-libseccomp \
               --disable-xzlib      \
               --disable-zlib
  make -j$(nproc)
popd

./configure --prefix=/usr --host=$lfstgt --build=$(./config.guess)

make FILE_COMPILE=$(pwd)/build/src/file

rm -v $lfs/usr/lib/libmagic.la


