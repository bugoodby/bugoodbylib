@echo off

set BATCHDIR=%~dp0

echo ==============================================
echo dir/file make
echo ==============================================
mkdir %BATCHDIR%test1\subdir1
mkdir %BATCHDIR%test1\subdir2
echo here is root. > %BATCHDIR%test1\README.txt
echo hogehoge > %BATCHDIR%test1\subdir1\file1.txt
echo piyopiyo > %BATCHDIR%test1\subdir1\file2_%date:/=-%.txt
echo fugafuga > %BATCHDIR%test1\subdir1\file3.log

mkdir %BATCHDIR%test1\subdir1\subdir1subdir
echo here is subdir of subdir1 > %BATCHDIR%test1\subdir1\subdir1subdir\README.txt

echo ==============================================
echo copy
echo ==============================================
rem /Y          受け側の既存のファイルを上書きする前に確認のメッセージを表示しません。

rem *** subdir1直下の全ファイルをsubdir2へコピー（サブフォルダはコピーされない）
rem *** subdir2は存在している必要がある
copy /Y "%BATCHDIR%test1\subdir1\*" "%BATCHDIR%test1\subdir2"
copy /Y "%BATCHDIR%test1\README.txt" "%BATCHDIR%test1\subdir2"
copy /Y "%BATCHDIR%test1\README.txt" "%BATCHDIR%test1\subdir2\README_copy.txt"

echo ==============================================
echo xcopy
echo ==============================================
rem /E          ディレクトリまたはサブディレクトリが空であってもコピーします。
rem /F          コピー中にコピー元とコピー先の全ファイル名を表示します。
rem /Y          既存のファイルを上書きする前に確認のメッセージを表示しません。

rem *** test1 下の全ファイルを test2\non_exist_folder\test1 へコピー（サブフォルダも）
rem *** non_exist_folder\test1 は自動で作られる
xcopy /E /F /Y "%BATCHDIR%test1" "%BATCHDIR%test2\non_exist_folder\test1\"

rem *** test1 下の全ファイルを test3~5 へコピー（サブフォルダも）
rem *** コピー先の末尾が\でない場合、事前にフォルダを作っておかなければならない
mkdir "%BATCHDIR%test3" "%BATCHDIR%test4" "%BATCHDIR%test5"
xcopy /E /F /Y "%BATCHDIR%test1" "%BATCHDIR%test3"
xcopy /E /F /Y "%BATCHDIR%test1" "%BATCHDIR%test4"
xcopy /E /F /Y "%BATCHDIR%test1" "%BATCHDIR%test5"

echo ==============================================
echo del
echo ==============================================
rem /S            指定されたファイルをすべてのサブディレクトリから削除します。
rem /Q            ワイルドカードを使用して一括削除するときに、確認のメッセージを表示しません。(QUIET モード)

rem *** test4 下の全ファイルを削除
rem *** サブフォルダ自体は残るが、サブフォルダ下のファイルは削除される
del /S /Q "%BATCHDIR%test4\*"

echo ==============================================
echo rmdir
echo ==============================================
echo これからtest5を削除します
pause
rem /S      指定されたディレクトリに加えて、そのディレクトリ内のすべてのディレクトリとファイルを削除します。
rem /Q      /S を指定してディレクトリ ツリーを削除するときに、確認のメッセージを表示しません。(QUIET モード)
rmdir /S /Q "%BATCHDIR%test5"

pause
