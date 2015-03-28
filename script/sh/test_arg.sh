#!/bin/sh

function usage()
{
	echo "usage: `basename $0` [-ab] files..."
	echo "  -a : ...."
	echo "  -b : ...."
}

if [ $# -eq 0 ]; then
	echo "arguments are not specified."
	usage
	exit 0
fi

echo "arguments are spedified."
echo "size=$#"

for arg in $@; do
	echo "$arg"
done

