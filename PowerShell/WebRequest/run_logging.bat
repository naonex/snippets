@echo off
rem powerShell���sbat

rem ���s�Ώ�ps1�t�@�C�������Z�b�g
SET runPs1=WebRequest.ps1

rem ���s�X�N���v�g�K�w�ֈړ�
cd %~dp0

rem ���s�����ݒ�
SET MAKE_DATE=%date:~0,4%%date:~5,2%%date:~8,2%
SET MAKE_TIME=%time:~0,2%%time:~3,2%%time:~6,2%%time:~9,2%
rem 0~9���̊Ԃɐ擪�ɍ쐬����锼�p�X�y�[�X��0�ɒu��������
SET MAKE_TIME=%MAKE_TIME: =0%
set datetime=%MAKE_DATE%T%MAKE_TIME%

rem ���O�o�͐ݒ�
set scriptName=%runPs1:.ps1=%
rem ���O�o�͐�f�B���N�g���쐬�i�R���\�[���o�͂͐؂�̂āj
mkdir log > NUL 2>&1
set logFilePath=log\%scriptName%_%datetime%.log

rem powerShell���琳�m�ɖ߂�l���󂯎���悤�ɃR�[��
powershell -NoProfile -ExecutionPolicy Unrestricted ".\%runPs1%;exit $LASTEXITCODE" >> %logFilePath%

echo. >> %logFilePath%
echo �߂�l�́u%ERRORLEVEL%�v >> %logFilePath%
