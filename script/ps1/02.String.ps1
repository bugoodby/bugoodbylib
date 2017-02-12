$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + '\'
. .\DebugTools.ps1

"---------------------------------------------"
" 前後の空白の除去"
"---------------------------------------------"
$str = "	   This is a test string!    	"
Write-Host "-" $str "-"
Write-Host "-" $str.Trim() "-"
Write-Host "-" $str.TrimStart() "-"
Write-Host "-" $str.TrimEnd() "-"

"---------------------------------------------"
" 先頭・末尾"
"---------------------------------------------"
$str = "あいうえお"
Write-Host $str[0]
Write-Host $str[-1]

"---------------------------------------------"
" 部分文字列"
"---------------------------------------------"
$str = "世界を驚すような大科学者になろうと思った者があろうか。"
$str.SubString(3)
$str.SubString(3, 5)

"---------------------------------------------"
" 改行コードの除去"
"---------------------------------------------"
$str = "L1: aaaaaaaaa`r`nL2: This is a test string!`n`r`nL4: aaa"
Write-Host $str

$str = $str.Replace("`r", "").Replace("`n", "")
Write-Host $str

"---------------------------------------------"
" 行ごとに分解"
"---------------------------------------------"
$str = "L1: aaaaaaaaa`r`nL2: This is a test string!`n`r`nL4:"

$lines = $str -split "`n" | % { $_.Replace("`r", "") }
$lines | % { "{0} ... {1}" -f $_, $_.Length }
