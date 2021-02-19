echo "Rev.2020.05.27"
echo "psでhttpリクエストループするスクリプト"
echo ""

while ($true) {
    Invoke-RestMethod -Uri "http://xxx.xxx.xxx.xxx/servlet/Test?ServerName=TestSV&ApplicationName=TestAPP" -Method GET
    Start-Sleep -s 1
}
