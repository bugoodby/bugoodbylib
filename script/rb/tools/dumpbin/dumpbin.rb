#!/usr/bin/ruby

def usage
	prog = __FILE__
	puts "Usage: #{prog} file"
end

if ARGV.length == 0
	usage()
	exit
end

i = 0; addr = 0; str = ""
infile = ARGV[0]

File.open(infile, "rb") {|f|
	f.each_byte do |bytedata|
		if ( i == 0 ) then
			printf("0x%08X: ", addr)
		end
		
		printf("%02X", bytedata)
		i += 1
		
		if ( (bytedata > 32) and (bytedata < 127) ) then
			str += bytedata.chr
		else
			str += "."
		end
		
		if ( i < 16 ) then
			print " "
		else
			print "  " + str + "\n"
			i = 0
			addr += 16
			str = ""
		end
	end
	
	if ( i != 0 ) then
		print "  "
		for j in 0..(15-(i+1)) do
			print "   "
		end
		print "  " + str + "\n"
	end
}


