
function func( $str1, $str2 ) {
	"func( {0}, {1} )" -f $str1, $str2
}

$scriptBlock = {
	PARAM([string]$str1, [string]$str2)
	"scriptBlock( {0}, {1} )" -f $str1, $str2
}

"***func***"
func "aaa" "bbb"
func "aaa", "bbb" # NG, ��1�����ɔz��œn���Ă��܂�

"***scriptBlock***"
& $scriptBlock
$scriptBlock.Invoke("aaa", "bbb")
