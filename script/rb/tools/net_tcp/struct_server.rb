#!/usr/bin/ruby

require "socket"
require "ipaddr"


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

def unpackTestStruct( src )
	data = {}
	data[:item1] = src[0, 1].unpack('C')[0]
	data[:item2] = src[1, 2].unpack('n')[0]
	data[:item3] = src[3, 4].unpack('N')[0]
	data[:len] = src[7, 4].unpack('N')[0]
	data[:msg] = src[11, data[:len]]
	return data
end

def packTestStructReply( src = {} )
	data = ''
	data << Array(src[:msg1].length).pack('N');
	data << src[:msg1]
	data << Array(src[:msg2].length).pack('N');
	data << src[:msg2]
	return data
end


#---------------------------------------
# main
#---------------------------------------
def main() 
	if ARGV.length == 0
		puts "usage: tcpserver_job.rb <port num>"
		exit
	end
	
	puts "*********** tcp server start (" + ARGV[0] + ") ***********"
	tcps = TCPServer.open("0.0.0.0", ARGV[0].to_i)

	loop {
		sock = tcps.accept
		puts "<accept>====================="
		print "server: "; p sock.addr
		print "client: "; p sock.peeraddr
		
		buf = sock.recv(65536)
		break if buf.length == 0
		printf("<recv> %d\n", buf.size)
		dumpbin(STDOUT, buf)
		p unpackTestStruct(buf)
		
		info = {
			:msg1 => "OK\n",
			:msg2 => "***メッセージの受信は成功しました***",
		}
		data = packTestStructReply(info)
		printf("<send> %d\n", data.size)
		sock.write(data)
		
		sock.close
		puts "<close>====================="
	}

	udps.close
end

main()
