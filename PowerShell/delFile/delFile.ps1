echo "REV 2019/08/11"
echo "�t�@�C���폜�c�[���i���K�\���Ō����j"
echo ""

# ���t�ݒ�
$exeTime = get-date -uf "%Y%m%dT%H%M%S%Z00"

# �Ώۃt�H���_�ȉ��̐��K�\���Ƀ}�b�`����t�@�C���E�t�H���_���擾
$targets = Get-ChildItem -R "C:\Users\testUser\Dropbox" | Where-Object { $_ -match ".*\.wma" }

echo "[�폜�Ώ�]"
echo $targets 
echo ""

$title = "*** ���s�m�F ***"
$message = "�폜���Ă�낵���ł����H"
$lastMessage = "�{���ɍ폜���Ă�낵���ł��ˁH"
$objYes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","�폜����"
$objNo = New-Object System.Management.Automation.Host.ChoiceDescription "&No","�폜���Ȃ�"
$objOptions = [System.Management.Automation.Host.ChoiceDescription[]]($objNo,$objYes)
$resultVal = $host.ui.PromptForChoice($title, $message, $objOptions, 0)
if ($resultVal -eq 0) { exit }
$resultVal = $host.ui.PromptForChoice($title, $lastMessage, $objOptions, 0)
if ($resultVal -eq 0) { exit }

foreach ($target in $targets) {
    echo $target.FullName
    Remove-Item $target.FullName
}