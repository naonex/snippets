echo "REV 2019/04/19"
echo "フォルダ名（正規表現）以下をgrep検索するツール"
echo ""

# 日付設定
$exeTime = get-date -uf "%Y%m%dT%H%M%S%Z00"

# 設定ファイル読み込み
Get-Content .\setting.ini | foreach {
    $line = $_.split("=")
    # splitしてnull・空文字でなければ変数化
    if ($line[0] -or $line[1]) {
        set-variable -name $line[0] -value $line[1]
    }
}

# GFOLDER以下の正規表現にマッチするファイル・フォルダを取得
$targets = Get-ChildItem "$GFOLDER" | Where-Object { $_ -match "$GFOLDER_REGEX" }
# テキスト出力しておく
echo $targets >> .\targets_${exeTime}.log

foreach ($GKEY in $GKEYS.split(",")) {
    echo "【「${GKEY}」grep検索ループ開始】"
    foreach ($target in $targets) {
        $searchGFOLDER = join-path $GFOLDER $target.Name
        echo "「${searchGFOLDER}」以下grep検索中・・・"
        start-process $sakuraExe -ArgumentList "-GREPMODE -GKEY=${GKEY} -GFILE=${GFILE} -GFOLDER=${searchGFOLDER} -GCODE=${GCODE} -GOPT=${GOPT}"
        # ※少し待機しないとサクラエディタがビジーになる
        start-sleep -m $sleepMilliseconds
    }
    echo ""
}
