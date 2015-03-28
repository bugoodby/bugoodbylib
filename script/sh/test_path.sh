#!/bin/sh

if [ $# -ne 1 ]; then
	echo "argument is not specified."
	exit 0
fi

echo "=== parse ==="
path=$1
echo "path                   : $path"
dirname=`dirname $path`
echo "directory name         : $dirname"
filename=`basename $path`
echo "file name              : $filename"
filename2=${filename%.*}
echo "file(without extension): $filename2"
ext=${filename##*.}
echo "extension              : $ext"
echo ""

echo "=== remove last / ==="
path="./test/exe/src/"
echo "path     : $path"
dir=${path%/}
echo "dir      : $dir"
echo ""

echo "=== remove first ./ ==="
path="./test/exe/src/"
echo "path     : $path"
dir=${path##./}
echo "dir      : $dir"
echo ""

