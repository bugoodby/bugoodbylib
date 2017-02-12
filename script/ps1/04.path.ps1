$path = "C:\Windows\notepad.exe"

"`n***Test-Path***"
Test-Path $path -PathType leaf
Test-Path $path -PathType container

"`n***Exists***"
[IO.File]::Exists($path)
[IO.Directory]::Exists($path)


"`n***System.IO.Path***"
[IO.Path]::GetDirectoryName($path)
[IO.Path]::GetFileName($path)
[IO.Path]::GetExtension($path)
[IO.Path]::GetFileNameWithoutExtension($path)

"`n***Split-Path***"
Split-Path -Path $path -Qualifier
Split-Path -Path $path -noQualifier
Split-Path -Path $path -Parent
Split-Path -Path $path -Leaf


"`n***ScriptDir***"
$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + '\'
$ScriptDir


"`n***Replace***"
$newFile = $path -Replace "\\[^\\]*$", "\replace.txt"
$newFile

$newExt = $path -Replace "\.[^\.]*$", ".newExt"
$newExt
