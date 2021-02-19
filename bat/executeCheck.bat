rem 実行確認
:exeCheck
ECHO 処理を実行しますか? (Y/N)
SET /p c=
if "%c%"=="Y" GOTO CONTINUE
if "%c%"=="y" GOTO CONTINUE
if "%c%"=="N" exit /b
if "%c%"=="n" exit /b
REM Y,y,N,n以外の場合は再度確認する
GOTO exeCheck

:CONTINUE