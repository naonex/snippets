#! /bin/bash

IPs=`cat <<EOS
xxx.xxx.xxx.xxx
yyy.yyy.yyy.yyy
EOS
`

for IP in $IPs; do
    ssh root@${IP} 'sudo df -h | sed -e "1,2d" | awk -v host_name=$(hostname) '\''BEGIN{OFS="\t"} { if($6==""){print(host_name, $2" / "$1, $4, $5)}else{print(host_name, $3" / "$2, $5, $6)}}'\'''
done
