#!/usr/bin/ruby
require "socket"

def main() 

	if ARGV.length == 0
		puts "usage: #{File.basename($0)} <ip addr> <port num> <file>"
		exit
	end
	
	puts "*** udp client ***"
	puts "  ip addr = " + ARGV[0]
	puts "  port    = " + ARGV[1]
	puts "  data    = " + ARGV[2]
	
	client = UDPSocket.open()
	sockaddr = Socket.pack_sockaddr_in(ARGV[1].to_i, ARGV[0])
	
	File.open(ARGV[2], "rb") {|f|
		sdata = f.read
		client.send(sdata, 0, sockaddr)
	}

	client.close
end

main()
