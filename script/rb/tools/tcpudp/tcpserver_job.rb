#!/usr/bin/ruby

require "socket"
require "date"
require "ipaddr"
require './PacketMaker.rb'

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

class DataFile
	def initialize()
		@fp = nil
	end
	
	def open()
		outfile = File.dirname(File.expand_path($0)) << "/job_" << Time.now.strftime("%Y%m%d_%H%M%S") << ".bin"
		@fp = File.open(outfile, "wb")
	end
	
	def write( data )
		@fp.write(data)
	end
	
	def close()
		@fp.close
	end
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

	df = DataFile.new

	loop {
		sock = tcps.accept
		puts "<accept>====================="
		p sock.peeraddr
		p sock.addr
		pm = PcapMakerTCP.new
		df.open()
		
		while buf = sock.gets
			printf("<recv> %d\n", buf.size)
#			dumpbin(STDOUT, buf)
			pm.addPcapPacket( buf, sock.addr, sock.peeraddr )
			df.write(buf)
		end
		
		sock.close
		puts "<close>====================="
		pm.makePcapFile("job")
		df.close
	}

	udps.close
end

main()
