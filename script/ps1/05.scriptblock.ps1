
function func( $str1, $str2 ) {
	"func( {0}, {1} )" -f $str1, $str2
}

$scriptBlock = {
	PARAM([string]$str1, [string]$str2)
	"scriptBlock( {0}, {1} )" -f $str1, $str2
}

"***funct***"
func "aaa" "bbb"
func -str1 "aaa" -str2 "bbb"
func "aaa", "bbb" # NG, 第1引数に配列で渡してしまう

"***scriptBlock***"
& $scriptBlock
& $scriptBlock "aaa" "bbb"
