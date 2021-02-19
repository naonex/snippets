#!/bin/bash

# 実行shの階層に移動
shDir=`dirname $0`
cd $shDir

# 実行時間をセット
exeTime=`date '+%Y%m%dT%H%M%S'`

SCP_OPTION="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
# ユーザ名
USER_NAME="testUser"
#出力先設定
COPY_DEST=${exeTime}

# ファイルを読み込む
SERVERS=`cat serverlist.txt`
FILES=`cat targetFiles.txt`
# 読み込んだデータを元にループ
for serverName in $SERVERS
do
    echo $serverName
    for file in $FILES
    do
        # 出力先ディレクトリ作成
        dirName=`dirname ${file}`
        mkdir -p ${COPY_DEST}/${serverName}${dirName}

        # fileと前方一致するファイルを検索しループ
        for target in `ssh ${USER_NAME}@${serverName} "sudo find ${file}*"`
        do
            echo $target
            ## SCPで取得
            #sudo scp ${SCP_OPTION} ${USER_NAME}@${serverName}:${target} ${COPY_DEST}/${serverName}${target}
            # ※権限的に無理だったのでsshからに変更
            ssh ${USER_NAME}@${serverName} "sudo cat ${target}" > ${COPY_DEST}/${serverName}${target}
        done
    done
done
