#!/usr/bin/ruby
# -*- coding: utf-8 -*-
require "optparse"


# 引数がなければUsage表示
def main1()
	def usage
		puts "Usage: #{File.basename($0)} file"
	end

	if ARGV.length == 0
		usage()
		return
	end
	
	puts "main1 exec!\n"
end

# OptionParserの使用
def main2()
	# parse option parameters.
	OptionParser.new("Usage: #{File.basename($0)} [options...] <file>") do |opt|
		opt.on('-h', '--help', 'show this message') { puts opt; exit }
		begin
			opt.parse!
		rescue
			puts "Invalid option.\n\n#{opt}"
			return
		end 
	end
	
	infile = ARGV[0] || "test.txt"
	
	if ( !FileTest.readable?(infile) )
		STDERR.puts "[ERROR] fail to open: " << infile
		return
	end
	
	puts "main2 exec!\n"
end



main1()
main2()
