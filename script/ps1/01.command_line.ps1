

Write-Host "Args:"
Write-Host ("  Count: {0}" -f $args.Length)
for ( $i = 0; $i -lt $args.length; $i++ ) {
	Write-Host ("  [{0}] : {1}" -f $i, $args[$i])
}

