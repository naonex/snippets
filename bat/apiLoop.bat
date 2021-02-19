
:LoopStart

curl --insecure "http://xxx.xxx.xxx.xxx/servlet/Test?ServerName=TestSV&ApplicationName=TestAPP"
curl -X POST -H "Content-Type: application/json" -d "{\"header\":{\"Result\":\"true\", \"Count\":0},\"data\":[{\"No\":0,\"Text\":\"test\",\"Date\":\"2016-07-01 14:18:21\",\"Timestamp\":\"2016-07-01 14:18:21.230809\"}]}" "http://xxx.xxx.xxx.xxx/servlet/Test2"

timeout /nobreak 1

GOTO LoopStart
