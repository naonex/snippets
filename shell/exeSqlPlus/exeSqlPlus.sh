#!/bin/bash
echo "**** sqlplus実行 ****"
echo "Rev.2019.01.29"

# 実行shの階層に移動
shDir=`dirname $0`
cd $shDir

# 実行時間をセット
exeTime=`date '+%Y%m%d%H%M%S'`

# 戻り値格納用変数
retCd=0

# confファイルを読み込む（1行目は切り捨て）
DATA=`cat dbconfig.conf | sed -e '1d'`
# 「=」でセパレートしてループ
while IFS=, read USER PASSWORD DATABASE
do
    echo
    # 以下の変数の値がセットされていなければエラーとする（パスワードはマスキングして表示）
    echo USER=$USER
    echo PASSWORD=${PASSWORD//?/*}
    echo DATABASE=$DATABASE

    # 変数の値確認
    if [ -z "$USER" -o -z "$PASSWORD" -o -z "$DATABASE" ]; then
        echo "confファイルが正しく設定されていません"
        # 戻り値に9を格納して次のループ処理へ
        retCd=9
        continue
    fi

    sqlplus -l ${USER}/${PASSWORD}@${DATABASE} @target.sql | tee target_${USER}_${exeTime}.log
    # sqlplusコマンドの戻り値が0でなければ、戻り値格納用変数に9をセットする
    if [ ! ${PIPESTATUS[0]} == 0 ]; then
        retCd=9
    fi

done << FILE
$DATA
FILE

# 戻り値を返して処理終了
exit $retCd
