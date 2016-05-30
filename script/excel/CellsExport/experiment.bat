@echo off

set BATCHDIR=%~dp0
set ORG_FILE=%BATCHDIR%CellsExport.xlsm
set IMPORT_TOOL=%BATCHDIR%CellsExportImport.js
set INPUT_DIR=%BATCHDIR%input
set OUTPUT_DIR=%BATCHDIR%output


rmdir /S /Q "%OUTPUT_DIR%"
mkdir "%OUTPUT_DIR%"


for %%A in (%INPUT_DIR%\*.txt) do (
	echo %%~fA
	copy /Y "%ORG_FILE%" "%OUTPUT_DIR%\%%~nA.xlsm"
	cscript "%IMPORT_TOOL%" /import "%%~fA" "%OUTPUT_DIR%\%%~nA.xlsm"
)


pause
