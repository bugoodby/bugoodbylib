#!/usr/bin/ruby

require "socket"
require "date"
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

class DataFile
	def initialize()
		@fp = nil
	end
	
	def open()
		outfile = File.dirname(File.expand_path($0)) << "/lpd_" << Time.now.strftime("%Y%m%d_%H%M%S") << ".bin"
		@fp = File.open(outfile, "wb")
	end
	
	def write( data )
		@fp.write(data)
	end
	
	def close()
		@fp.close
	end
end


def recv_job_loop( sock )
	data_flg = false
	df = DataFile.new
	df.open

	while buf = sock.recv(65535)
		printf("<recv> %d\n", buf.size)
		dumpbin(STDOUT, buf)
		
		if ( data_flg == true ) then
			if ( buf.size == 0 || (buf.size == 1 && buf[0] == "\x00") ) then
				sock.write("\0")
				break
			else
				df.write(buf)
			end
		else
			if buf[0] == "\x03" then
				# Receive data file
				data_flg = true
			end
		end
		
		sock.write("\0")
#		STDIN.getc
	end
	
	df.close
end


#---------------------------------------
# main
#---------------------------------------
def main() 
	
	puts "*********** tcp server start (515) ***********"
	tcps = TCPServer.open("0.0.0.0", 515)

	loop {
		sock = tcps.accept
		puts "<accept>====================="
		p sock.peeraddr
		p sock.addr
		
		while buf = sock.recv(65535)
			printf("<recv> %d\n", buf.size)
			dumpbin(STDOUT, buf)
			
			break if buf.size == 0
			
			if buf[0] == "\x02" then
				# Receive a printer job
				sock.write("\0")
				recv_job_loop(sock)
			end
			
			sock.write("\0")
		end
		
		sock.close
		puts "<close>====================="
	}

	udps.close
end

main()
