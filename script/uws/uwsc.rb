#!/bin/ruby

$uwscApp = "C:\mywork\UWSC\UWSC.exe"
$scriptDir = File.dirname(File.expand_path($0))

if ( ARGV.length == 0 ) then
	puts "invalid arguments."
	exit 1
end

if ( ! File.exist?($uwscApp) )
	puts "NOT FOUND: #$uwscApp"
	exit 1
end

cmd = "\"#$uwscApp\" \"#{ARGV[0]}\""
puts cmd
p system(cmd)

puts "uwsc executed."
