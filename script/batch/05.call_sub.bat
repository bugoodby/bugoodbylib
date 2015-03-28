@echo off

echo callee : %cd%

echo callee : wait 10s start
ping localhost -n 10 > nul
echo callee : wait 10s end

