@echo off
rem powerShell���sbat

rem ���s�Ώ�ps1�t�@�C�������Z�b�g
SET runPs1=WebRequest.ps1

rem powerShell���琳�m�ɖ߂�l���󂯎���悤�ɃR�[��
powershell -NoProfile -ExecutionPolicy Unrestricted ".\%runPs1%;exit $LASTEXITCODE"

echo.
echo �߂�l�́u%ERRORLEVEL%�v

pause