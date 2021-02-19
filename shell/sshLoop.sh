# sshコマンドを並列実行させるテストツール

for ((i=0; i < 10; i++))
do
    ssh root@192.168.56.11 "echo test ${i}" &
done

wait
