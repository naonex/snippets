rem 実行スクリプト階層へ移動
cd %~dp0

rem 実行日時設定
SET MAKE_DATE=%date:~0,4%%date:~5,2%%date:~8,2%
SET MAKE_TIME=%time:~0,2%%time:~3,2%%time:~6,2%%time:~9,2%
rem 0~9時の間に先頭に作成される半角スペースを0に置き換える
SET MAKE_TIME=%MAKE_TIME: =0%
set datetime=%MAKE_DATE%T%MAKE_TIME%

rem ログ出力設定
set scriptName=%~n0
rem ログ出力先ディレクトリ作成（コンソール出力は切り捨て）
mkdir log > NUL 2>&1
set logFilePath=log\%scriptName%_%datetime%.log
