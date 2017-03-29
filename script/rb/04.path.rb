#!/bin/ruby
require "date"

path = 'C:\Windows\notepad.exe'


puts "*** ファイル存在確認 ***"
p File.exist?(path)
p Dir.exist?(path)
puts ''

puts "*** パスの分解 ***"
puts "  Dir:    " << File.dirname(path)
puts "  File:   " << File.basename(path)
puts "  Ext:    " << File.extname(path)
puts ''


puts "*** パスの編集 ***"
#パスのファイル名にprefix追加
puts "  add Prefix:  " << File.dirname(path) << "/prefix_" << File.basename(path) << "\n"
#パスのファイル名にpostfix追加
puts "  add Postfix: " << path.sub(/(\.[^.]+)$/, '_postfix\1') << "\n"
#パスの拡張子を変更
puts "  change ext:  " << path.sub(/\.[^.]+$/, ".bin") << "\n"
#パスと同じディレクトリの日付.txt
puts "  today file:  " << File.dirname(path) << "/" << Time.now.strftime("%Y%m%d_%H%M%S") << ".txt" << "\n"
puts ''




puts "*** スクリプト自身のパス ***"
puts "  Path:          " << $0 << "\n"
puts "  Path (Full):   " << File.expand_path($0) << "\n"
puts "  Dir:           " << File.dirname($0) << "\n"
puts "  Dir (Full):    " << File.dirname(File.expand_path($0)) << "\n"
puts "  File:          " << File.basename($0) << "\n"
puts "  Ext:           " << File.extname($0) << "\n"

#スクリプトと同じディレクトリ
scriptDir = File.dirname(File.expand_path($0))
puts "  ScriptDir:     " << scriptDir

#スクリプトと同じディレクトリにあるxxx.txt
scriptDirFile = File.join( File.dirname(File.expand_path($0)), "xxx.txt")
puts "  ScriptDirFile: " << scriptDirFile


