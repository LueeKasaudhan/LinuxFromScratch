case $(uname -m) in
    i?86)   ln -sfv ld-linux.so.2 $lfs/lib/ld-lsb.so.3
    ;;
    x86_64) ln -sfv ../lib/ld-linux-x86-64.so.2 $lfs/lib64
            ln -sfv ../lib/ld-linux-x86-64.so.2 $lfs/lib64/ld-lsb-x86-64.so.3
    ;;
esac

patch -Np1 -i ../glibc-2.41-fhs-1.patch

mkdir -v build
cd       build

echo "rootsbindir=/usr/sbin" > configparms

../configure                             \
      --prefix=/usr                      \
      --host=$lfstgt                    \
      --build=$(../scripts/config.guess) \
      --enable-kernel=5.4                \
      --with-headers=$lfs/usr/include    \
      --disable-nscd                     \
      libc_cv_slibdir=/usr/lib

make -j1
make DESTDIR=$lfs install


sed '/RTLDLIST=/s@/usr@@g' -i $lfs/usr/bin/ldd

