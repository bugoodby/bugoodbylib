#!/usr/bin/ruby
require "socket"
require "date"
require "json"

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

def execScript(data)
    j = JSON.parse(data)
    p `osascript ./airprint.scpt "#{j['tag']}" "#{j['data']}" "#{j['printer']}" "#{j['ori']}" "#{j['staple']}" "#{j['punch']}"`
end

#---------------------------------------
# main
#---------------------------------------
def main() 

	if ARGV.length == 0
		puts "usage: #{File.basename($0)} <port num>"
		exit
	end
	
	puts "*********** udp server start (" + ARGV[0] + ") ***********"
	udps = UDPSocket.open()
	udps.bind("0.0.0.0", ARGV[0].to_i)
	p udps.addr()

	loop do
		rdata, raddr = udps.recvfrom(65535)
		print "<recv>=====================\n"
		p raddr
		dumpbin(STDOUT, rdata)
        execScript(rdata)
	end

	udps.close
end

main()
