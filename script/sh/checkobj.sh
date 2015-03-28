#!/bin/sh

if [ $# -eq 0 ]; then
	echo "usage: $0 <object>"
	exit 1
fi

echo "** soname **"
objdump -x $1 | grep "SONAME"
echo ""

echo "** NEEDED libraries **"
objdump -x $1 | grep "NEEDED"
echo ""

echo "** UNDEF symbols **"
objdump -t $1 | grep "*UND*"
echo ""
nm -C -u $1 | grep " U "
echo ""

echo "** UNDEF symbols (dynamic symbol table) **"
objdump -T $1 | grep "*UND*"
echo ""
nm -C -u -D $1 | grep " U "
echo ""

echo "** .TEXT section **"
nm -C $1 | grep " T "
echo ""

echo "** .TEXT section (dynamic symbol table) **"
nm -C -D $1 | grep " T "
echo ""

