"======================="
" Get-Variable"
"======================="
Get-Variable

"======================="
" PSVersionTable"
"======================="
$PSVersionTable.GetType()
$PSVersionTable

"======================="
" Get-ExecutionPolicy"
"======================="
Get-ExecutionPolicy

"======================="
" Host"
"======================="
$Host.GetType()
$Host

"======================="
" Loded Assemblies"
"======================="
[System.AppDomain]::CurrentDomain.GetAssemblies()
