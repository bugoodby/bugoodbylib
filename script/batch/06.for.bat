@echo off
set BATCHDIR=%~dp0

echo *********************

for %%A in (*.bat) do (
	echo %%~fA
)

echo *********************

for /d %%A in (..\*) do (
	echo %%~fA
)

pause
