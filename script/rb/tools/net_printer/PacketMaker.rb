
#-----------------------------------
# pcap maker base
#-----------------------------------
class PcapMakerBase
	def initialize()
		@packets = []
	end

	def addPcapPacket( data, laddr, raddr )
	end

	def makePcapFile( prefix )
		len = 0
		@packets.each { |p|
			len += p.size
		}
		p len
		
		# pcap file header
		header = ""
		header.encode!("ASCII-8BIT")
		header << [ 0xa1b2c3d4 ].pack("V*") # magic
		header << [ 2, 4 ].pack("v*") # version
		header << [ 0, 0, 0xFFFF, 0x1 ].pack("V*") # timezone, sigfigs, snaplen, linktype
		
		outfile = File.dirname(File.expand_path($0)) << "/" << prefix << "_" << Time.now.strftime("%Y%m%d_%H%M%S") << ".pcap"
		File.open(outfile, "wb") {|f|
			f.write(header)
			@packets.each { |p|
				f.write(p)
			}
		}
	end
end


#-----------------------------------
# UDP pcap maker
#-----------------------------------
class PcapMakerUDP < PcapMakerBase
	def initialize()
		super()
	end
	
	def addPcapPacket( data, laddr, raddr )
		packet = ""
		packet.encode!("ASCII-8BIT")
		
		# pcap packet header
		packet << [ 0xCCCCCCCC ].pack("V*")
		packet << [ 0xDDDDDDDD ].pack("V*")
		packet << [ data.size + 42 ].pack("V*") # caplen
		packet << [ data.size + 42 ].pack("V*") # len
		
		# Ethernet Header (14 bytes)
		ether_dhost = [ 0x00, 0x50, 0x56, 0xC0, 0x00, 0x08 ]
		ether_shost = [ 0x00, 0x50, 0x56, 0xC0, 0x00, 0x08 ]
		packet << ether_dhost.pack("C*")
		packet << ether_shost.pack("C*")
		packet << [ 0x0800 ].pack("n*") # ether_type (=IP)
		
		# IP Header (20 bytes)
		packet << 0x45 # version & header len
		packet << 0x00 # TOS
		packet << [ data.size + 28 ].pack("n*") # total len
		packet << [ 0x1234 ].pack("n*") # ID
		packet << [ 0x0000 ].pack("n*") # Offset
		packet << 0xFF # TTL
		packet << 0x11 # Protocol (=UDP)
		packet << [ 0x0000 ].pack("n*") # Checksum
		packet << IPAddr.new( raddr[3] ).hton # Src Address
		packet << IPAddr.new( laddr[3] ).hton # Dst Address
		
		# UDP Header (8 bytes)
		packet << [ raddr[1] ].pack("n*") # Src Port
		packet << [ laddr[1] ].pack("n*") # Dst Port
		packet << [ data.size + 8 ].pack("n*") # total len
		packet << [ 0x0000 ].pack("n*") # Checksum
		
		packet << data
		
		@packets.push( packet )
	end
end

#-----------------------------------
# TCP pcap maker
#-----------------------------------
class PcapMakerTCP < PcapMakerBase
	def initialize()
		super()
	end
	
	def addPcapPacket( data, laddr, raddr )
		packet = ""
		packet.encode!("ASCII-8BIT")
		
		# pcap packet header
		packet << [ 0xCCCCCCCC ].pack("V*")
		packet << [ 0xDDDDDDDD ].pack("V*")
		packet << [ data.size + 54 ].pack("V*") # caplen
		packet << [ data.size + 54 ].pack("V*") # len
		
		# Ethernet Header (14 bytes)
		ether_dhost = [ 0x00, 0x50, 0x56, 0xC0, 0x00, 0x08 ]
		ether_shost = [ 0x00, 0x50, 0x56, 0xC0, 0x00, 0x08 ]
		packet << ether_dhost.pack("C*")
		packet << ether_shost.pack("C*")
		packet << [ 0x0800 ].pack("n*") # ether_type (=IP)
		
		# IP Header (20 bytes)
		packet << 0x45 # version & header len
		packet << 0x00 # TOS
		packet << [ data.size + 40 ].pack("n*") # total len
		packet << [ 0x1234 ].pack("n*") # ID
		packet << [ 0x0000 ].pack("n*") # Offset
		packet << 0xFF # TTL
		packet << 0x06 # Protocol (=TCP)
		packet << [ 0x0000 ].pack("n*") # Checksum
		packet << IPAddr.new( raddr[3] ).hton # Src Address
		packet << IPAddr.new( laddr[3] ).hton # Dst Address
		
		# TCP Header (20 bytes)
		packet << [ raddr[1] ].pack("n*") # Src Port
		packet << [ laddr[1] ].pack("n*") # Dst Port
		packet << [ 0x00000000 ].pack("N*") # Seq Num
		packet << [ 0x00000000 ].pack("N*") # Ack Num
		packet << [ 0x5002 ].pack("n*") # len & flags (=SYN)
		packet << [ 0xFFFF ].pack("n*") # Window Size
		packet << [ 0x0000 ].pack("n*") # Checksum
		packet << [ 0x0000 ].pack("n*") # Urgent
		
		packet << data
		
		@packets.push( packet )
	end
end
