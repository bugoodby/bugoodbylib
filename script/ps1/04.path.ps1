$path = "C:\Windows\notepad.exe"

"`n***Test-Path***"
Test-Path $path -PathType leaf
Test-Path $path -PathType container

"`n***Exists***"
[System.IO.File]::Exists($path)
[System.IO.Directory]::Exists($path)


"`n***System.IO.Path***"
[System.IO.Path]::GetDirectoryName($path)
[System.IO.Path]::GetFileName($path)
[System.IO.Path]::GetExtension($path)
[System.IO.Path]::GetFileNameWithoutExtension($path)

"`n***Split-Path***"
Split-Path -Path $path -Qualifier
Split-Path -Path $path -noQualifier
Split-Path -Path $path -Parent
Split-Path -Path $path -Leaf


"`n***ScriptDir***"
$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + '\'
$ScriptDir
