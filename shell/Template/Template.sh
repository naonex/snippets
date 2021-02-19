#!/bin/bash

# ※cronから実行する場合は、標準出力をターミナルに返さないこと（logファイル等に出力させること）
# 　ターミナルに返された標準出力は実行ユーザー宛てのメールとして出力されます

#echo "Template"
#echo "Rev.2020.04.08"
#echo 

# 実行shの階層に移動
shDir=`dirname $0`
cd $shDir

# 実行時間をセット
exeTime=`date '+%Y%m%dT%H%M%S'`
# ログ出力設定
scriptName=`basename $0 .sh`
mkdir -p log
logFile=log/${scriptName}_${exeTime}.log

# configファイルを読み込む
DATA=`cat config.ini`
# 「=」でセパレートしてループ
while IFS== read key val
do
    # 空行はスキップ
    if [ -z "${key}" ]; then continue; fi
    # SECTION判定
    if [[ ${key} == \[*\] ]]; then
        SECTION=${key}; #echo $SECTION
        continue
    fi
    # Target1,Target2
    if [[ ${SECTION} == "[Target1]" ]] || [[ ${SECTION} == "[Target2]" ]]; then
        #echo ${key}=${val}
        declare ${key}=${val}
    fi
done << FILE
$DATA
FILE

#echo 
#echo "実行中・・・"
echo "【StartTime】`date '+%Y/%m/%d %H:%M:%S.%N'`" >> $logFile
sleep 10
echo "【EndTime】`date '+%Y/%m/%d %H:%M:%S.%N'`" >> $logFile
