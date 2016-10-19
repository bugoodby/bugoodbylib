#!/bin/ruby
require "date"

def subfunc()
	#スクリプト自身のパス
	puts "subfunc()"
	puts "  Path:          " << $0 << "\n"
	puts "  Path (Full):   " << File.expand_path($0) << "\n"
	puts "  Dir:           " << File.dirname($0) << "\n"
	puts "  Dir (Full):    " << File.dirname(File.expand_path($0)) << "\n"
	puts "  File:          " << File.basename($0) << "\n"
	puts "  Ext:           " << File.extname($0) << "\n"
	#スクリプトと同じディレクトリにあるxxx.txt
	puts "  ScriptDirFile: " << File.dirname(File.expand_path($0)) << "/xxx.txt" << "\n"
	puts "  ScriptDirFile: " << File.join( File.dirname(File.expand_path($0)), "xxx.txt") << "\n"
	puts "\n"
end

