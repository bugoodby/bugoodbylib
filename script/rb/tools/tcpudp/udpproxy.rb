#!/usr/bin/ruby
require "socket"
require "date"
require "optparse"
require 'ipaddr'
require './PacketMaker.rb'

$flg_pcap = false
$count = 0

def saveRecvData( data, ip )
	outfile = File.dirname(File.expand_path($0)) << "/proxy_" << $count.to_s << "_" << Time.now.strftime("%Y%m%d_%H%M%S") << "_from" << ip << ".bin"
	File.open(outfile, "wb") {|f|
		f.write(data)
	}
	$count += 1
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


SERVER_IP = "192.168.11.1"
SERVER_PORT = 47545

#---------------------------------------
# main
#---------------------------------------
def main() 
	
	# parse option parameters.
	OptionParser.new("Usage: ruby #{File.basename($0)} [options]") do |opt|
		opt.on('-p', 'output pcap file') { $flg_pcap = true }
		opt.on('-h', '--help', 'show this message') { puts opt; exit }
		begin
			opt.parse!
		rescue
			puts "Invalid option.\n\n#{opt}"
			exit
		end 
	end

	clientaddr = nil
	saddr = nil
	
	if ( $flg_pcap )
		pm = PcapMakerUDP.new
	end
	
	puts "*********** udp proxy start ***********"
	udps = UDPSocket.open()
	udps.bind("0.0.0.0", SERVER_PORT)
	laddr = $udps.addr()
	p laddr
	
	begin
		loop do
			rdata, raddr = udps.recvfrom(65535)
			print "<recv>=====================\n"
			p raddr
			if ( $flg_pcap )
				pm.addPcapPacket( rdata, laddr, raddr )
			else
				saveRecvData(rdata, raddr[3])
			end
			dumpbin(STDOUT, rdata)
			
			print "<send>=====================\n"
			if ( raddr[3] != SERVER_IP )
				clientaddr = raddr.clone
				saddr = Socket.pack_sockaddr_in(SERVER_PORT, SERVER_IP)
				puts "  -> #{SERVER_PORT}, #{SERVER_IP}"
			else
				saddr = Socket.pack_sockaddr_in(clientaddr[1], clientaddr[3])
				puts "  -> #{clientaddr[1]}, #{clientaddr[3]}"
			end
			udps.send(rdata, 0, saddr)
		end
	rescue Interrupt
		puts "Ctl+C!"
		if ( $flg_pcap )
			pm.makePcapFile("job")
		end
	ensure
	end

	udps.close
end

main()



