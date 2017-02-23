#!/bin/sh

ARGV=("$@")
i=0
while [ $i -lt $# ]; do
	echo "$i = ${ARGV[$i]}"
	if [ "${ARGV[i]:0:4}" = "VAL=" ]; then
		VAL=`echo ${ARGV[i]} | cut -d '=' -f 2`
	fi
	i=`expr $i + 1`
done

if [ "$VAL" = "" ]; then
	echo "NOT SET"
else
	echo "VAL: $VAL"
fi
