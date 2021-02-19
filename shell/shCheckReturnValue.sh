#!/bin/bash

# 実行shの階層を取得し変数に格納
shDir=`dirname $0`

sh ${shDir}/target.sh

echo "戻り値は$?です"
