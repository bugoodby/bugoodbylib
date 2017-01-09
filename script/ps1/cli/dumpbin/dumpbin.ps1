$str = ""
$cnt = 0
get-content -encoding byte $args[0] | foreach-object {
	$str += ("{0:x2} " -f $_)
	if ($cnt++ -eq 15) {
		$cnt = 0
		$str += "`n"
	}
}
write-host $str

$path = Split-Path ( & { $myInvocation.ScriptName } ) -parent
write-output $str | Out-File -FilePath ($path + "\output.txt")
