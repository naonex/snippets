@echo off

rem カウント用設定
SET BASECOUNT=900000000
SET COUNTERFILE=No.txt

:LoopStart

rem カウンターファイルを読み込む（1行目のみ）
for /f %%a in (No.txt) do (SET SUBSTR=%%a & GOTO next)
:next
rem カウントアップ（カウンターファイル更新）
SET /a SUBSTR=%SUBSTR%+1
echo %SUBSTR% > %COUNTERFILE%

rem 番号作成（999%SUBSTR%）
SET /a SUBSTR=%BASECOUNT%+%SUBSTR%
IF %SUBSTR% GTR 999999999 (echo ※カウントアップの限界に到達しました！処理を終了します！※ & pause & exit /b)

echo 番号：%SUBSTR%

curl -X POST -H "Content-Type: application/json" -d "{\"header\":{\"Result\":\"true\", \"Count\":0},\"data\":[{\"No\":%SUBSTR%,\"Text\":\"test\",\"Date\":\"2016-07-01 14:18:21\",\"Timestamp\":\"2016-07-01 14:18:21.230809\"}]}" "http://xxx.xxx.xxx.xxx/servlet/Test2"

timeout /nobreak 1

GOTO LoopStart
