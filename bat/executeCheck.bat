rem ���s�m�F
:exeCheck
ECHO ���������s���܂���? (Y/N)
SET /p c=
if "%c%"=="Y" GOTO CONTINUE
if "%c%"=="y" GOTO CONTINUE
if "%c%"=="N" exit /b
if "%c%"=="n" exit /b
REM Y,y,N,n�ȊO�̏ꍇ�͍ēx�m�F����
GOTO exeCheck

:CONTINUE