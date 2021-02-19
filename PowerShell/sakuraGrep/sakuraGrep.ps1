echo "REV 2019/04/19"
echo "�t�H���_���i���K�\���j�ȉ���grep��������c�[��"
echo ""

# ���t�ݒ�
$exeTime = get-date -uf "%Y%m%dT%H%M%S%Z00"

# �ݒ�t�@�C���ǂݍ���
Get-Content .\setting.ini | foreach {
    $line = $_.split("=")
    # split����null�E�󕶎��łȂ���Εϐ���
    if ($line[0] -or $line[1]) {
        set-variable -name $line[0] -value $line[1]
    }
}

# GFOLDER�ȉ��̐��K�\���Ƀ}�b�`����t�@�C���E�t�H���_���擾
$targets = Get-ChildItem "$GFOLDER" | Where-Object { $_ -match "$GFOLDER_REGEX" }
# �e�L�X�g�o�͂��Ă���
echo $targets >> .\targets_${exeTime}.log

foreach ($GKEY in $GKEYS.split(",")) {
    echo "�y�u${GKEY}�vgrep�������[�v�J�n�z"
    foreach ($target in $targets) {
        $searchGFOLDER = join-path $GFOLDER $target.Name
        echo "�u${searchGFOLDER}�v�ȉ�grep�������E�E�E"
        start-process $sakuraExe -ArgumentList "-GREPMODE -GKEY=${GKEY} -GFILE=${GFILE} -GFOLDER=${searchGFOLDER} -GCODE=${GCODE} -GOPT=${GOPT}"
        # �������ҋ@���Ȃ��ƃT�N���G�f�B�^���r�W�[�ɂȂ�
        start-sleep -m $sleepMilliseconds
    }
    echo ""
}
