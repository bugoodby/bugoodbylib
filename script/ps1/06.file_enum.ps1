
function ShowName( $path )
{
	[IO.Path]::GetFileName($path)
}

while($true) {
	$path = Read-Host "Input path"

	if ( $path[0] -eq '"' -and $path[-1] -eq '"' ) {
		$path = $path.SubString(1, ($path.Length-2))
	}

	if ( [IO.Directory]::Exists($path) ) {
		"[Directory]"
		Get-ChildItem -Recurse -LiteralPath $path | ?{ ! $_.PSIsContainer } | % {
			if ( [IO.Path]::GetExtension($_) -eq ".cpp" ) {
				ShowName $_
			}
		}
	} else {
		"[File]"
		if ( [IO.Path]::GetExtension($path) -eq ".cpp" ) {
			ShowName $path
		}
	}
}

