#!/usr/bin/ruby
require "socket"
require "date"

def saveRecvData( data )
	outfile = File.dirname(File.expand_path($0)) << "/client_" << Time.now.strftime("%Y%m%d_%H%M%S") << ".bin"
	File.open(outfile, "wb") {|f|
		f.write(data)
	}
end

def loadSendData( file )
	sdata = ""
	File.open(file, "rb") {|f|
		sdata = f.read
	}
	return sdata
end

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

# send data list
$sdlist = [
	"get_device.bin",
	"get_device.bin"
]
$i = 0

def sendData( sock )
	print "<send>=====================\n"
	puts $sdlist[$i]
	sdata = loadSendData( File.join( File.dirname(File.expand_path($0)), $sdlist[$i] ) )
	dumpbin(STDOUT, sdata)
	sockaddr = Socket.pack_sockaddr_in(47545, "127.0.0.1")
	sock.send(sdata, 0, sockaddr)
	$i += 1
end

puts "*********** udp client start ***********"
udpc = UDPSocket.open()
udpc.bind("0.0.0.0", 0)

sendData(udpc)
loop do
	rdata, raddr = udpc.recvfrom(65535)
	print "<recv>=====================\n"
	p raddr
	saveRecvData(rdata)
	dumpbin(STDOUT, rdata)
	
	sendData(udpc)
end

udps.close


