#!/bin/sh

FIND_FLAG="src"
GREP_FLAG=1
PATTERN=""
EXTENSION=""
GREPOPT="-in"

# usage
function usage()
{
	CMDNAME=`basename $0`
	echo "" 1>&2
	echo "usage: $CMDNAME [-l] [-a] [-h] [-s extension] pattern" 1>&2
	echo "  -l : list files only. \"pattern\" is ignored." 1>&2
	echo "  -a : target is all files." 1>&2
	echo "  -h : target is *.h;*.hpp;*.hxx" 1>&2
	echo "  -s : target is \"extension\"." 1>&2
	echo "" 1>&2
	exit 1
}

# get options.
ARGV=("$@")
i=0
while [ $i -lt $# ]; do
	#echo "$i = ${ARGV[$i]}"
	if [ "${ARGV[i]:0:1}" = "-" ]; then
		case "${ARGV[i]:1:1}" in
		l) GREP_FLAG=0 ;;
		a) FIND_FLAG="all" ;;
		h) FIND_FLAG="header" ;;
		s) FIND_FLAG="specified"; i=`expr $i + 1`; EXTENSION=${ARGV[$i]} ;;
		*) echo "[!] unexpected option ${ARGV[$i]}" 1>&2; usage ;;
		esac
	else
		PATTERN=${ARGV[$i]}
	fi
	i=`expr $i + 1`
done
if [ $GREP_FLAG -eq 1 -a "$PATTERN" = "" ]; then
	echo "[!] 'pattern' is not specified." 1>&2
	exit 1
fi


#while getopts "lahs:" flag; do
#	case $flag in
#	l) GREP_FLAG=0 ;;
#	a) FIND_FLAG="all" ;;
#	h) FIND_FLAG="header" ;;
#	s) FIND_FLAG="specified" ; EXTENSION=$OPTARG ;;
#	*) usage ;;
#	esac
#done
#shift `expr $OPTIND - 1`
#if [ $# -gt 0 ]; then
#	PATTERN=$1
#fi


# for debug
echo "DEBUG: FIND_FLAG=$FIND_FLAG GREP_FLAG=$GREP_FLAG EXTENSION=$EXTENSION PATTERN=$PATTERN GREPOPT=$GREPOPT" 1>&2

case $FIND_FLAG in
	all)
		if [ $GREP_FLAG -eq 0 ]; then
			find . -print
		else
			find . -print | xargs grep $GREPOPT "$PATTERN"
		fi
		;;
	src)
		if [ $GREP_FLAG -eq 0 ]; then
			find . \( -iname "*.[c|h]" -o -iname "*.[c|h]pp" -o -iname "*.[c|h]xx" \) -print
		else
			find . \( -iname "*.[c|h]" -o -iname "*.[c|h]pp" -o -iname "*.[c|h]xx" \) -print | xargs grep $GREPOPT "$PATTERN"
		fi
		;;
	header)
		if [ $GREP_FLAG -eq 0 ]; then
			find . \( -iname "*.h" -o -iname "*.hpp" -o -iname "*.hxx" \) -print
		else
			find . \( -iname "*.h" -o -iname "*.hpp" -o -iname "*.hxx" \) -print | xargs grep $GREPOPT "$PATTERN"
		fi
		;;
    specified)
		if [ $GREP_FLAG -eq 0 ]; then
			find . -iname "$EXTENSION" -print
		else
			find . -iname "$EXTENSION" -print | xargs grep $GREPOPT "$PATTERN"
		fi
		;;
    *)
        ;;
esac


