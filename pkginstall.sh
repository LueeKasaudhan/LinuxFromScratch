chapter="$1"
package="$2"

if [[ "$package" == "libstdc++" ]] ; then
	echo "Libstdc++ is the standard C++ library. It is needed to compile C++ code (part of GCC is written in C++)"
	echo "Compiling $package"
	echo "Entering gcc-14.2.0 directory"
	pushd "$LFS/sources/gcc-14.2.0/"
	if ! source "$LFS/sources/chapter$chapter/$package.sh" 2>&1 | tee "$LFS/sources/chapter$chapter/$package.log" ; then
		echo "Error compiling $package"
		exit 1
	fi
	popd
fi

if [[ "$package" == "glibc" ]] ; then
	deppkg="linux-api-headers"
	if [ -d ./linux-6.13.4 ] ; then
		rm -rf ./linux-6.13.4/
	fi
	mkdir -pv ./linux-6.13.4/
	echo "glibc dependent on the $deppkg"
	echo "Extracting linux-6.13.4 kernel source code for compiling $deppkg"
	tar -xf ./linux-6.13.4.tar.xz -C linux-6.13.4 --strip-components=1
	pushd ./linux-6.13.4/
	echo "Compiling $deppkg"
	if ! source "$LFS/sources/chapter$chapter/$deppkg.sh" 2>&1 | tee "$LFS/sources/chapter$chapter/$deppkg.log" ; then
		echo "Error compiling $deppkg. $package can't be compiled."
		exit 1
	fi
	popd
	echo "Removing linux kernel source"
	rm -rf ./linux-6.13.4
fi
	

cat ./lfspackages | grep -i ""$package"-" | awk '{print $3}' | grep -i -v ".patch" | while read -r line; do
	dirname="$(echo "$line" | sed 's/\.tar\..*//')"
	if [ -d "$dirname" ]; then
		rm -rf "$dirname"
	fi
	mkdir -pv "$dirname"
	echo "Extracting $line"
	tar -xf "$line" -C "$dirname"
	sleep 2
	pushd "$dirname"
		if [ "$(ls -1A | wc -l)" == "1" ]; then
			mv $(ls -1A)/* ./
		fi
		echo "Compiling $package"
		sleep 5
		if ! source "$LFS/sources/chapter$chapter/$package.sh" 2>&1 | tee "$LFS/sources/chapter$chapter/$package.log" ; then
			echo "Error compiling $package"
			exit 1
		fi
		echo "$package Compilation Successful"
		popd
	done


#for file in *; do
#	dirname="$(echo "$file" | sed 's/\.tar\..*//')"
#	if [[ ! -d "$dirname" && -f "$file" && "$file" == *.tar.* ]]; then
#		echo "Extracting $file"
#		tar -xf $file -C "$dirname"
#	else
#		if [[ -d "$dirname" ]]; then
#			echo "$dirname already exists"
#		fi
#		if [[ -f "$file" && "$file" == *.tar.* ]];then
#			echo "$file already Extracted"
#		fi
#		if [[ -f "$file" && "$file" != *.tar.* ]]; then
#			echo "$file not a tar file"
#		fi
#		if [ -d "$file" ]; then
#			echo "$file is a directory"
#		fi
#	fi
#done



