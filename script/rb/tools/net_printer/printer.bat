set BATCHDIR=%~dp0
start ruby -Ku %BATCHDIR%\udpserver.rb 47545
start ruby -Ku %BATCHDIR%\tcpserver_job.rb 9100
start ruby -Ku %BATCHDIR%\tcpserver_lpd.rb
