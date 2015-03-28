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
rem /Y          �󂯑��̊����̃t�@�C�����㏑������O�Ɋm�F�̃��b�Z�[�W��\�����܂���B

rem *** subdir1�����̑S�t�@�C����subdir2�փR�s�[�i�T�u�t�H���_�̓R�s�[����Ȃ��j
rem *** subdir2�͑��݂��Ă���K�v������
copy /Y "%BATCHDIR%test1\subdir1\*" "%BATCHDIR%test1\subdir2"
copy /Y "%BATCHDIR%test1\README.txt" "%BATCHDIR%test1\subdir2"
copy /Y "%BATCHDIR%test1\README.txt" "%BATCHDIR%test1\subdir2\README_copy.txt"

echo ==============================================
echo xcopy
echo ==============================================
rem /E          �f�B���N�g���܂��̓T�u�f�B���N�g������ł����Ă��R�s�[���܂��B
rem /F          �R�s�[���ɃR�s�[���ƃR�s�[��̑S�t�@�C������\�����܂��B
rem /Y          �����̃t�@�C�����㏑������O�Ɋm�F�̃��b�Z�[�W��\�����܂���B

rem *** test1 ���̑S�t�@�C���� test2\non_exist_folder\test1 �փR�s�[�i�T�u�t�H���_���j
rem *** non_exist_folder\test1 �͎����ō����
xcopy /E /F /Y "%BATCHDIR%test1" "%BATCHDIR%test2\non_exist_folder\test1\"

rem *** test1 ���̑S�t�@�C���� test3~5 �փR�s�[�i�T�u�t�H���_���j
rem *** �R�s�[��̖�����\�łȂ��ꍇ�A���O�Ƀt�H���_������Ă����Ȃ���΂Ȃ�Ȃ�
mkdir "%BATCHDIR%test3" "%BATCHDIR%test4" "%BATCHDIR%test5"
xcopy /E /F /Y "%BATCHDIR%test1" "%BATCHDIR%test3"
xcopy /E /F /Y "%BATCHDIR%test1" "%BATCHDIR%test4"
xcopy /E /F /Y "%BATCHDIR%test1" "%BATCHDIR%test5"

echo ==============================================
echo del
echo ==============================================
rem /S            �w�肳�ꂽ�t�@�C�������ׂẴT�u�f�B���N�g������폜���܂��B
rem /Q            ���C���h�J�[�h���g�p���Ĉꊇ�폜����Ƃ��ɁA�m�F�̃��b�Z�[�W��\�����܂���B(QUIET ���[�h)

rem *** test4 ���̑S�t�@�C�����폜
rem *** �T�u�t�H���_���͎̂c�邪�A�T�u�t�H���_���̃t�@�C���͍폜�����
del /S /Q "%BATCHDIR%test4\*"

echo ==============================================
echo rmdir
echo ==============================================
echo ���ꂩ��test5���폜���܂�
pause
rem /S      �w�肳�ꂽ�f�B���N�g���ɉ����āA���̃f�B���N�g�����̂��ׂẴf�B���N�g���ƃt�@�C�����폜���܂��B
rem /Q      /S ���w�肵�ăf�B���N�g�� �c���[���폜����Ƃ��ɁA�m�F�̃��b�Z�[�W��\�����܂���B(QUIET ���[�h)
rmdir /S /Q "%BATCHDIR%test5"

pause
