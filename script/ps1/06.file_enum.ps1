$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0


function Get-FileList( $path, $recurse, $ext )
{
	if ( $recurse ) {
		Get-ChildItem -Recurse -LiteralPath $path | ?{ ! $_.PSIsContainer } | % {
			if ( [IO.Path]::GetExtension($_) -eq $ext ) {
				Write-Host $_.Name
			}
		}
	} else {
		Get-ChildItem -LiteralPath $path | ?{ ! $_.PSIsContainer } | % {
			if ( [IO.Path]::GetExtension($_) -eq $ext ) {
				Write-Host $_.Name
			}
		}
	}
}

function Get-DirectoryList( $path, $recurse )
{
	if ( $recurse ) {
		Get-ChildItem -Recurse -LiteralPath $path | ?{ $_.PSIsContainer } | % {
			Write-Host $_
		}
	} else {
		Get-ChildItem -LiteralPath $path | ?{ $_.PSIsContainer } | % {
			Write-Host $_
		}
	}
}

while($true) {
	Write-Host "-------------------------"
	Write-Host "0 : File"
	Write-Host "1 : File (recurse)"
	Write-Host "2 : Directory"
	Write-Host "3 : Directory (recurse)"
	Write-Host "q : quit"
	Write-Host "-------------------------"

	$input = Read-Host "Select number"
	if ( $input -eq "q" ) { 
		exit 1
	}
	$num = [int]$input


	$path = Read-Host "Input path"
	if ( $path[0] -eq '"' -and $path[-1] -eq '"' ) {
		$path = $path.SubString(1, ($path.Length-2))
	}

	switch ( $num )
	{
	0 { Get-FileList $path $false ".ps1" }
	1 { Get-FileList $path $true ".ps1" }
	2 { Get-DirectoryList $path $false }
	3 { Get-DirectoryList $path $true }
	default { Write-Host "invalid number!" }
	}

}


