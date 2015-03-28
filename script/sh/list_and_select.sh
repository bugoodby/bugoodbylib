#!/bin/sh

ary=(`rpm -qa | grep "gcc"`)
echo "----------[ grep result list ]----------"
for i in `seq 0 $((${#ary[@]}-1))`; do echo "[$i] ${ary[$i]}"; done
echo "[q] quit"
echo "----------------------------------------"
echo -n "please select number> "
read INPUT
if [ "$INPUT" = "q" ]; then exit; fi

echo $INPUT $((INPUT))
echo ${ary[$((INPUT))]}

