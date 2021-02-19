echo "REV 2019/08/11"
echo "ファイル削除ツール（正規表現で検索）"
echo ""

# 日付設定
$exeTime = get-date -uf "%Y%m%dT%H%M%S%Z00"

# 対象フォルダ以下の正規表現にマッチするファイル・フォルダを取得
$targets = Get-ChildItem -R "C:\Users\testUser\Dropbox" | Where-Object { $_ -match ".*\.wma" }

echo "[削除対象]"
echo $targets 
echo ""

$title = "*** 実行確認 ***"
$message = "削除してよろしいですか？"
$lastMessage = "本当に削除してよろしいですね？"
$objYes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","削除する"
$objNo = New-Object System.Management.Automation.Host.ChoiceDescription "&No","削除しない"
$objOptions = [System.Management.Automation.Host.ChoiceDescription[]]($objNo,$objYes)
$resultVal = $host.ui.PromptForChoice($title, $message, $objOptions, 0)
if ($resultVal -eq 0) { exit }
$resultVal = $host.ui.PromptForChoice($title, $lastMessage, $objOptions, 0)
if ($resultVal -eq 0) { exit }

foreach ($target in $targets) {
    echo $target.FullName
    Remove-Item $target.FullName
}