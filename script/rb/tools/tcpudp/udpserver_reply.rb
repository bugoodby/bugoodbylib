#!/usr/bin/ruby
require "socket"

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


#---------------------------------------
# main
#---------------------------------------
def main() 

	if ARGV.length == 0
		puts "usage: udpserver_reply.rb <port num>"
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
		sockaddr = Socket.pack_sockaddr_in(raddr[1], raddr[3])
		udps.send(rdata, 0, sockaddr)
	end

	udps.close
end

main()
