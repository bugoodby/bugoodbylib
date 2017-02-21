
"======================="
" Check Alias"
"======================="
$clsAccelerators = "System.Management.Automation.TypeAccelerators"
[psobject].Assembly.GetType($clsAccelerators)::Get

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
