$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + '\'
. .\DebugTools.ps1

"---------------------------------------------"
" �O��̋󔒂̏���"
"---------------------------------------------"
$str = "	   This is a test string!    	"
Write-Host "-" $str "-"
Write-Host "-" $str.Trim() "-"
Write-Host "-" $str.TrimStart() "-"
Write-Host "-" $str.TrimEnd() "-"

"---------------------------------------------"
" �擪�E����"
"---------------------------------------------"
$str = "����������"
Write-Host $str[0]
Write-Host $str[-1]

"---------------------------------------------"
" ���s�R�[�h�̏���"
"---------------------------------------------"
$str = "L1: aaaaaaaaa`r`nL2: This is a test string!`n`r`nL4: aaa"
Write-Host $str

$str = $str.Replace("`r", "").Replace("`n", "")
Write-Host $str

"---------------------------------------------"
" �s���Ƃɕ���"
"---------------------------------------------"
$str = "L1: aaaaaaaaa`r`nL2: This is a test string!`n`r`nL4:"

$lines = $str -split "`n" | % { $_.Replace("`r", "") }
$lines | % { "{0} ... {1}" -f $_, $_.Length }
