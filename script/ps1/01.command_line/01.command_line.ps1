
"Count: {0}`n" -f $args.length

"Args:"
foreach ( $a in $args ) {
	Write-Output "$a"
}
""

"Args:"
for ( $i = 0; $i -lt $args.length; $i++ ) {
	"[{0}] : {1}" -f $i, $args[$i]
	[String]::Format("[{0}] : {1}", $i, $args[$i])
	[String]::Format("[{0}] : {1}", $i, $args[$i]) | Write-Output
}
""


