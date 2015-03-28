#!/bin/sh

function usage()
{
	echo ""
	echo "copy source files"
    echo "usage: `basename $0` src dst"
	echo ""
}


function copy_svn_workdir()
{
	local src=${1%/}
	local dst=${2%/}
	
	echo "------------------------------"
	echo "$src ==> $dst"
	echo "------------------------------"
	
	local candidates=`find $src \( \! -path '*/.svn' -and \! -path '*/.svn/*' -and \! -path '*/reftree/*' \)`

    for c in ${candidates[@]}; do
		c2=${c##${src}/}
        if [ -f $c ]; then
            c2d=$(dirname ${dst}/${c2})
			if [ ! -d $c2d ]; then
				echo " + $c2d"
				mkdir -p $c2d
			fi
			echo "      ${dst}/${c2}"
            cp $c ${dst}/${c2}
        else
            echo "(ignore $c)"
        fi
    done
}

function copy_git_workdir()
{
	local src=${1%/}
	local dst=${2%/}
	
	echo "------------------------------"
	echo "$src ==> $dst"
	echo "------------------------------"
	
	local candidates=`find $src \( \! -path '*/.git' -and \! -path '*/.git/*' -and \! -path '*/reftree/*' \)`

    for c in ${candidates[@]}; do
		c2=${c##${src}/}
        if [ -f $c ]; then
            c2d=$(dirname ${dst}/${c2})
			if [ ! -d $c2d ]; then
				echo " + $c2d"
				mkdir -p $c2d
			fi
			echo "      ${dst}/${c2}"
            cp $c ${dst}/${c2}
        else
            echo "(ignore $c)"
        fi
    done
}

function copy_source_files()
{
	local src=${1%/}
	local dst=${2%/}
	
	echo "------------------------------"
	echo "$src ==> $dst"
	echo "------------------------------"
	
	local candidates=`find $src \( -iname '*.cpp' -or -iname '*.cxx' -or -iname '*.c' -or -iname '*.h' \)`

    for c in ${candidates[@]}; do
		c2=${c##${src}/}
        if [ -f $c ]; then
            c2d=$(dirname ${dst}/${c2})
			if [ ! -d $c2d ]; then
				echo " + $c2d"
				mkdir -p $c2d
			fi
			echo "      ${dst}/${c2}"
            cp $c ${dst}/${c2}
        else
            echo "(ignore $c)"
        fi
    done
}

function add_lcov_excl()
{
	echo "------------------------------"
	echo " add lcov comment"
	echo "------------------------------"
	for file in `find $1 -type f`; do
		echo "  - $file"
		sed -i -e "1i // LCOV_EXCL_START" $file
		echo "// LCOV_EXCL_STOP" >> $file
	done
}

if [ $# -ne 2 ]; then
    usage
    exit 0
fi

copy_source_files $1 $2
add_lcov_excl $2



