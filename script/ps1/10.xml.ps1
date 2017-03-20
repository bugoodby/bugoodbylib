$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0
#$host.EnterNestedPrompt()

$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + '\'

# �ǂݍ���
$path = $ScriptDir + '10.test.xml'
$xmlDoc = [xml](Get-Content $path)

# �l�̕ύX
$xmlDoc.FORMAT.RECORD.FIELD[0].ID = "100"

# �����o��
$saveFile = $ScriptDir + '_10.test_after.xml'
$enc = New-Object System.Text.UTF8Encoding($false)
$xmlWriter = New-Object System.Xml.XmlTextWriter($SaveFile, $enc)
$xmlWriter.Formatting = [System.Xml.Formatting]::Indented
$xmlDoc.Save($xmlWriter)
$xmlWriter.Close()

