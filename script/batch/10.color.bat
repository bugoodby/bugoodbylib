@echo off

set BATCHDIR=%~dp0
pushd %BATCHDIR%

echo 変更前

color C
echo 変更後

popd
pause
