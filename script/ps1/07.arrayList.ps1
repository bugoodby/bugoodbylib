$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0
#$host.EnterNestedPrompt()

$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + '\'
. .\DebugTools.ps1


function Test_ArrayList()
{
	$list = New-Object System.Collections.ArrayList
	
	
	# 要素の追加
	[void]$list.Add( 5 )
	[void]$list.Add( 'hoge' )
	[void]$list.Add( 0.3 )
	[void]$list.Add( 'fuga' )
	[void]$list.Add( 'piyo' )
	
	Write-Host "Value =" $list #=> 5, 'hoge', 0.3, 'fuga', 'piyo'
	Write-Host "Count =" $list.Count #=> 5
	
	# 要素の削除
	$list.Remove( 0.3 )
	$list.RemoveAt( 2 )
	
	Write-Host "Value =" $list #=> 5, 'hoge', 'piyo'
	Write-Host "Count =" $list.Count #=> 3
	
	# 要素の挿入
	$list.Insert( 1, 'INSERT' )
	
	Write-Host "Value =" $list #=> 5, 'INSERT', 'hoge', 'piyo'
	Write-Host "Count =" $list.Count #=> 4
	
	# 要素のクリア
	$list.Clear()
	
	Write-Host "Value =" $list #=> 
	Write-Host "Count =" $list.Count #=> 0
	
	
	# 要素の追加
	1..10 | %{ [void]$list.Add($_) }
	# 要素の参照
	foreach ( $item in $list ) {
		Write-Host "Item:" $item
	}
	
	# Object[]に変換
	$objectArray = $list.ToArray()
	Write-Host "Type   =" $objectArray.GetType().FullName #=> System.Object[]
	Write-Host "Value  =" $objectArray
	Write-Host "Length =" $objectArray.Length
}

Test_ArrayList

