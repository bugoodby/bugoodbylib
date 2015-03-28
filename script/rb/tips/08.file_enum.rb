#!/bin/ruby
require 'find'

def enum_files_all( dir )
	Find.find(dir) do |f|
		if ( File.directory?(f) )
			print "dir : "
			puts f
		else
			print "file: "
			puts f
		end
	end
end

def enum_files_ext( dir )
	Find.find(dir) do |f|
		if ( File.file?(f) && File.extname(f) == ".rb" )
			puts f
		end
	end
end

def enum_files_name( dir )
	Find.find(dir) do |f|
		if ( File.file?(f) && /file/ =~ File.basename(f) )
			puts f
		end
	end
end

def enum_files_name2( dir )
	Find.find(dir) do |f|
		if ( File.file?(f) && /file_([^\.]+)\./ =~ File.basename(f) )
			puts f
			puts $1
		end
	end
end

root = ARGV[0] || Dir.pwd

puts "=== all ==="
enum_files_all(root)

puts "=== ext ==="
enum_files_ext(root)

puts "=== name ==="
enum_files_name(root)

puts "=== name2 ==="
enum_files_name2(root)
