patch -Np1 -i ../glibc-2.40-fhs-1.patch
mkdir -v build
cd build
touch /etc/ld.so.conf
echo "rootsbindir=/usr/sbin" > configparms

../configure --prefix=/usr                            \
             --disable-werror                         \
             --enable-kernel=4.19                     \
             --enable-stack-protector=strong          \
             --disable-nscd                           \
             libc_cv_slibdir=/usr/lib

make -j$(nproc)
make check



