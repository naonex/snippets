@echo off

rem �J�E���g�p�ݒ�
SET BASECOUNT=900000000
SET COUNTERFILE=No.txt

:LoopStart

rem �J�E���^�[�t�@�C����ǂݍ��ށi1�s�ڂ̂݁j
for /f %%a in (No.txt) do (SET SUBSTR=%%a & GOTO next)
:next
rem �J�E���g�A�b�v�i�J�E���^�[�t�@�C���X�V�j
SET /a SUBSTR=%SUBSTR%+1
echo %SUBSTR% > %COUNTERFILE%

rem �ԍ��쐬�i999%SUBSTR%�j
SET /a SUBSTR=%BASECOUNT%+%SUBSTR%
IF %SUBSTR% GTR 999999999 (echo ���J�E���g�A�b�v�̌��E�ɓ��B���܂����I�������I�����܂��I�� & pause & exit /b)

echo �ԍ��F%SUBSTR%

curl -X POST -H "Content-Type: application/json" -d "{\"header\":{\"Result\":\"true\", \"Count\":0},\"data\":[{\"No\":%SUBSTR%,\"Text\":\"test\",\"Date\":\"2016-07-01 14:18:21\",\"Timestamp\":\"2016-07-01 14:18:21.230809\"}]}" "http://xxx.xxx.xxx.xxx/servlet/Test2"

timeout /nobreak 1

GOTO LoopStart
