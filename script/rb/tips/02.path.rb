#!/bin/ruby
require "date"

#-----------------------------------------------------------
# main
#-----------------------------------------------------------
def main()
	#スクリプト自身のパス
	puts "Script"
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
	
	#引数で指定されたファイルのパス
	if ( ARGV.length > 0 )
		path = File.expand_path(ARGV[0])
		puts "Specified File"
		puts "  Path:   " << path << "\n"
		puts "  Dir:    " << File.dirname(path) << "\n"
		puts "  File:   " << File.basename(path) << "\n"
		puts "  Ext:    " << File.extname(path) << "\n"
		
		#パスのファイル名にprefix追加
		puts "  add Prefix: " << File.dirname(path) << "/prefix_" << File.basename(path) << "\n"
		#パスのファイル名にpostfix追加
		puts "  add Postfix: " << path.sub(/(\.[^.]+)$/, '_postfix\1') << "\n"
		#パスの拡張子を変更
		puts "  change ext:  " << path.sub(/\.[^.]+$/, ".bin") << "\n"
		#パスと同じディレクトリの日付.txt
		puts "  today file: " << File.dirname(path) << "/" << Time.now.strftime("%Y%m%d_%H%M%S") << ".txt" << "\n"
	end
end


main()
