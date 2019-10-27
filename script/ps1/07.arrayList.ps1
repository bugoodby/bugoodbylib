$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0
#$host.EnterNestedPrompt()

$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + '\'
. .\DebugTools.ps1


function Test_ArrayList()
{
	$list = New-Object System.Collections.ArrayList
	
	
	# —v‘f‚Ì’Ç‰Á
	[void]$list.Add( 5 )
	[void]$list.Add( 'hoge' )
	[void]$list.Add( 0.3 )
	[void]$list.Add( 'fuga' )
	[void]$list.Add( 'piyo' )
	
	Write-Host "Value =" $list #=> 5, 'hoge', 0.3, 'fuga', 'piyo'
	Write-Host "Count =" $list.Count #=> 5
	
	# —v‘f‚Ìíœ
	$list.Remove( 0.3 )
	$list.RemoveAt( 2 )
	
	Write-Host "Value =" $list #=> 5, 'hoge', 'piyo'
	Write-Host "Count =" $list.Count #=> 3
	
	# —v‘f‚Ì‘}“ü
	$list.Insert( 1, 'INSERT' )
	
	Write-Host "Value =" $list #=> 5, 'INSERT', 'hoge', 'piyo'
	Write-Host "Count =" $list.Count #=> 4
	
	# —v‘f‚ÌƒNƒŠƒA
	$list.Clear()
	
	Write-Host "Value =" $list #=> 
	Write-Host "Count =" $list.Count #=> 0
	
	
	# —v‘f‚Ì’Ç‰Á
	1..10 | %{ [void]$list.Add($_) }
	# —v‘f‚ÌŽQÆ
	foreach ( $item in $list ) {
		Write-Host "Item:" $item
	}
	
	# Object[]‚É•ÏŠ·
	$objectArray = $list.ToArray()
	Write-Host "Type   =" $objectArray.GetType().FullName #=> System.Object[]
	Write-Host "Value  =" $objectArray
	Write-Host "Length =" $objectArray.Length
}

Test_ArrayList

