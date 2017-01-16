
function func( $str1, $str2 ) {
	"func( {0}, {1} )" -f $str1, $str2
}

$scriptBlock = {
	PARAM([string]$str1, [string]$str2)
	"scriptBlock( {0}, {1} )" -f $str1, $str2
}

"***func***"
func "aaa" "bbb"
func -str1 "aaa" -str2 "bbb"
func "aaa", "bbb" # NG, ‘æ1ˆø”‚É”z—ñ‚Å“n‚µ‚Ä‚µ‚Ü‚¤

"***scriptBlock***"
& $scriptBlock
& $scriptBlock "aaa" "bbb"
