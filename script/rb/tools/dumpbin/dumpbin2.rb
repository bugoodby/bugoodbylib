#!/usr/bin/ruby

def dumpbin( f, data )
	dumpLine = lambda {|d, o|
		chars = ""
		line = sprintf("0x%08X: ", o)
		d.each_byte do |bytedata|
			line << sprintf("%02X ", bytedata)
			chars << ((bytedata >= 0x20 && bytedata <= 0x7e) ? bytedata.chr : '.')
		end
		line << "   " * (16 - d.length)
		return (line + " " + chars + "\n")
	}
	offset = 0
	while d = data[offset, 16]
		f.print dumpLine.call(d, offset)
		offset += 16
	end
end



def usage
	puts "usage: #{File.basename($0)} <file>"
end

if ARGV.length == 0
	usage()
	exit
end

infile = ARGV[0]
File.open(infile, "rb") {|f|
	dumpbin(STDOUT, f.read)
}


