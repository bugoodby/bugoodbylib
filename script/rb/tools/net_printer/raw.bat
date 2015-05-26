set BATCHDIR=%~dp0
ruby -Ku "%BATCHDIR%\tcpclient.rb" 127.0.0.1 9100 "%1"
pause
