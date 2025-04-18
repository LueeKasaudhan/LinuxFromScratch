chapter="$1"
package="$2"

cat ./lfspackages | grep -i "$package" | awk '{print $3}' | grep -i -v ".patch" | while read -r line; do
	dirname="$(echo "$line" | sed 's/\.tar\..*//')"
	if [ -d "$dirname" ]; then
		rm -rf "$dirname"
	fi
	mkdir -pv "$dirname"
	echo "Extracting $line"
	tar -xf "$line" -C "$dirname"
	
	pushd "$dirname"
		if [ "$(ls -1A | wc -l)" == "1" ]; then
			mv $(ls -1A)/* ./
		fi
		echo "Compiling $package"
		if ! source "$lfs/sources/chapter$chapter/$package.sh" 2>&1 | tee "$lfs/sources/chapter$chapter/$package.log" ; then
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



