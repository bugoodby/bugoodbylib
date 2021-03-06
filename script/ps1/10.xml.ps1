$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0
#$host.EnterNestedPrompt()

$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + '\'

$enc = New-Object System.Text.UTF8Encoding($false)

# 読み込み
$path = $ScriptDir + '10.test.xml'
#$xmlDoc = [xml](Get-Content $path)
$xmlDoc = [xml][System.IO.File]::ReadAllText($path, $enc)

# 値の変更
$xmlDoc.FORMAT.RECORD.FIELD[0].ID = "100"

# 書き出し
$saveFile = $ScriptDir + '_10.test_after.xml'
$xmlWriter = New-Object System.Xml.XmlTextWriter($saveFile, $enc)
$xmlWriter.Formatting = [System.Xml.Formatting]::Indented
$xmlDoc.Save($xmlWriter)
$xmlWriter.Close()

