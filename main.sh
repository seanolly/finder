#!/bin/bash

# searches file for keyword/s, copies, to specified directory
# w appended grep result, if successful.
handleFile() {
    local file=$1
    local directory=$2
    local keywords=$3
    local grepResult=$(grep -ni $keywords "$file")
    if [ -z "$grepResult" ];
        then echo $file:"keywords not present"
    else
	cp "$file" "$directory"/"$file"
	echo "*** match found in" "$file"
	echo "***"$grepResult >> "$directory"/"$file"
    fi
}

# searches each directory for keywords
handleDirectory() {
    local currentDirectory=$1
    local outputDirectory=$2
    local keywords=$3
    for item in "$currentDirectory"/*;
    do 
        name=$(basename $item)
        if [ -f "$item" ];
        then handleFile "$name" $outputDirectory "$keywords"
       elif [ -d "$item" -a ! "$name" != "$outputDirectory" ];
        then handleDirectory "$name" $outputDirectory "$keywords"
       fi
    done
}

directory=$(pwd)
read -p "keyword/s? " keyword
read -p "output directory? " outputDirectory
mkdir "$outputDirectory"
echo "looking through:" $(pwd) ...
echo "outputting to:" "$outputDirectory"
handleDirectory $directory "$outputDirectory" "$keyword"
echo "done!"
