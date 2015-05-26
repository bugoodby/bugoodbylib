#!/usr/bin/ruby
require "socket"
require "date"
require "optparse"
require 'ipaddr'
require './PacketMaker.rb'

$flg_pcap = false


def dumpbin( f, data )
	return if ( data == nil )
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
# TCPProxy
#---------------------------------------
class TCPProxy
	def initialize( p_ip, p_port, s_ip, s_port )
		@f = STDOUT
		@proxy = TCPServer.open( p_ip, p_port )
		@server = nil
		@client = nil
		@request_thread = nil
		@response_thread = nil
		
		if ( $flg_pcap )
			@pm = PcapMakerTCP.new
		end
		
		run( s_ip, s_port )
	end
	
	def run( ip, port )
		loop {
			@client = @proxy.accept
			@f.puts "<accept>====================="
			p @client.peeraddr
			p @client.addr
			
			@server = TCPSocket.open( ip, port )
			p @server.addr
			p @server.peeraddr
			
			listen_server()
			listen_client()
			
			@response_thread.join
			@request_thread.join
			
			if ( $flg_pcap )
				@pm.makePcapFile("job")
			end
			
			@f.puts "run() end"
		}
	end
	
	def listen_server()
		@response_thread = Thread.new do
			loop {
				buf = @server.gets
				@f.puts "<recv> ====================="
				@f.puts "[ Server => Client ]"
				dumpbin( @f, buf )
				if ( $flg_pcap )
					@pm.addPcapPacket( buf, @server.addr, @server.peeraddr )
				end
				@client.puts( buf )
			}
			@f.puts "response_thread end"
		end
		@f.puts "listen_server start"
	end
	
	def listen_client()
		@request_thread = Thread.new do
			while buf = @client.gets
				@f.puts "<recv> ====================="
				@f.puts "[ Client => Server ]"
				dumpbin( @f, buf )
				if ( $flg_pcap )
					@pm.addPcapPacket( buf, @client.addr, @client.peeraddr )
				end
				@server.puts( buf )
			end
			@f.puts "request_thread end"
		end
		@f.puts "listen_client start"
	end
end



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
	
	puts "*********** tcp proxy start ***********"
	TCPProxy.new( "192.168.11.5", 8632, "192.168.11.3", 8632 )
end

main()

