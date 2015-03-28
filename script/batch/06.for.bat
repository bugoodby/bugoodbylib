@echo off

set BATCHDIR=%~dp0

for %%A in (*.bat) do echo %%A

for %%A in (*.bat) do (
	echo %%~fA
)


pause
