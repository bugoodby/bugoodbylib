$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0
#$host.EnterNestedPrompt()

$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + '\'

"---------------------------------------------"
" 前後の空白の除去"
""
$str = "	   This is a test string!    	"
Write-Host "-" $str "-"
Write-Host "-" $str.Trim() "-"
Write-Host "-" $str.TrimStart() "-"
Write-Host "-" $str.TrimEnd() "-"

"---------------------------------------------"
" 大文字・小文字変換"
""
$str = " aa bb cc "
Write-Host $str.ToUpper()
$str = " AA BB CC "
Write-Host $str.ToLower()

"---------------------------------------------"
" 比較"
""
$str1 = " aa bb cc "
$str2 = " AA BB CC "

#大文字・小文字を区別しないで比較
Write-Host "$str1 -eq $str2 : $( $str1 -ieq $str2 )"

#大文字・小文字を区別してで比較
Write-Host "$str1 -ceq $str2 : $( $str1 -ceq $str2 )"

"---------------------------------------------"
" 正規表現演算子"
""
$str1 = "aa bb cc"

$result = $str1 -match "(\s.+\s)"
Write-Host "result=$result matches=$($matches[1])"

"---------------------------------------------"
" 部分一致の判定"
""
$str1 = "aa bb cc"

Write-Host ($str1.indexOf("bb") -ne -1)
Write-Host $str1.contains("bb")

"---------------------------------------------"
" 先頭・末尾"
""
$str = "あいうえお"
Write-Host $str[0]
Write-Host $str[-1]

"---------------------------------------------"
" 部分文字列"
""
$str = "世界を驚すような大科学者になろうと思った者があろうか。"
$str.SubString(3) #3文字目から末尾まで
$str.SubString(3, 5) #3文字目から5文字分

"---------------------------------------------"
" 改行コードの除去"
""
$str = "L1: aaaaaaaaa`r`nL2: This is a test string!`n`r`nL4: aaa"
Write-Host $str

$str = $str.Replace("`r", "").Replace("`n", "")
Write-Host $str

"---------------------------------------------"
" 行ごとに分解"
""
$str = "L1: aaaaaaaaa`r`nL2: This is a test string!`n`r`nL4:"

$lines = $str -split "`n" | % { $_.Replace("`r", "") }
$lines | % { "{0} ... {1}" -f $_, $_.Length }
