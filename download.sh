cat ./lfspackages | while read -r line ; do
	url=$( echo "$line" | awk '{print $1}' ) 
	filename=$( echo "$line" | awk '{print $3}' | awk -F'-' '{print $1}' )
	#version=$( echo "$line" | awk '{print $3}' | sed 's/\.tar\..*//' |  )
	checksum=$( echo "$line" | awk '{print $2}' )
	cachefile=$( echo "$line" | awk '{print $3}' )

	if [ ! -f "$cachefile" ] ; then
		wget -c "$url"
		if ! echo "$checksum $cachefile" | md5sum -c ; then
			echo "$filename MD5 mismatch. Failed"
			exit 1
		else
			echo "$filename MD5 verification successful"
		fi
	fi

done
