#!/bin/ruby

puts "---------------------------------------------"
puts " 前後の空白の除去"
puts ""
str = "	   This is a test string!    	"
puts "-" + str + "-"
puts "-" + str.strip + "-"
puts "-" + str.lstrip + "-"
puts "-" + str.rstrip + "-"

puts "---------------------------------------------"
puts " 大文字・小文字変換"
puts ""
str = " aa bb cc "
puts str.upcase
str = " AA BB CC "
puts str.downcase

puts "---------------------------------------------"
puts " 比較"
puts ""
str1 = " aa bb cc "
str2 = " AA BB CC "

#大文字・小文字を区別しないで比較
puts "str1 == str2 : " + (str1 == str2).to_s

#大文字・小文字を区別してで比較
puts "str1.casecmp(str2) : " + (str1.casecmp(str2) == 0).to_s

puts "---------------------------------------------"
puts " 正規表現演算子"
puts ""
str1 = "aa bb cc"

result = (/(\s.+\s)/ =~ str1)
puts "result=#{result} matches=#{$1}"

puts "---------------------------------------------"
puts " 部分一致の判定"
puts ""
str1 = "aa bb cc"

puts (str1.index("bb") != nil)
puts (str1.include?("bb"))

puts "---------------------------------------------"
puts " 先頭・末尾"
puts ""
str = "あいうえお"
puts str[0]
puts str[-1]

puts "---------------------------------------------"
puts " 部分文字列"
puts ""
str = "世界を驚すような大科学者になろうと思った者があろうか。"
puts str[3..-1] #3文字目から末尾まで
puts str[3, 5] #3文字目から5文字分

puts "---------------------------------------------"
puts " 改行コードの除去"
puts ""
str = "L1: aaaaaaaaa\r\nL2: This is a test string!\n\r\nL4: aaa"
puts str

str.gsub!(/(\r\n|\r|\n)/, "")
puts str

puts "---------------------------------------------"
puts " 行ごとに分解"
puts ""
str = "L1: aaaaaaaaa\r\nL2: This is a test string!\n\r\nL4:"

str.lines {|l| puts l.chomp }

str.lines {|l|
	puts "#{l.chomp} ... #{l.chomp.length}"
}
