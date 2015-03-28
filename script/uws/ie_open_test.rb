#!/bin/ruby

$uwscApp = "D:\\mydoc\\Documents\\app\\UWSC\\uwsc501\\UWSC.exe"
$scriptDir = File.dirname(File.expand_path($0))

cmd = "\"#$uwscApp\" \"#$scriptDir/ie_open.uws\" \"http://mirrors.axint.net/apache/abdera/\""
puts cmd
p system(cmd)

