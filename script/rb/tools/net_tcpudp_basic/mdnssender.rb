#!/usr/bin/ruby
require "socket"
require "ipaddr"

TARGET_PORT = 5353              # UDP通信ポート(MDNS)
MULTICAST_ADDR = "224.0.0.251"  # 参加するマルチキャストグループのアドレス
INTERFACE_ADDR = "192.168.11.3"  # 自身のインターフェースのアドレス


def main() 

	if ARGV.length == 0
		puts "usage: #{File.basename($0)} <ip addr> <port num> <file>"
		exit
	end
	
	puts "*** mdns client ***"
	puts "  data    = " + ARGV[0]
	
	client = UDPSocket.open()

#	mreq = IPAddr.new( MULTICAST_ADDR ).hton + IPAddr.new( INTERFACE_ADDR ).hton
#	client.setsockopt(Socket::IPPROTO_IP, Socket::IP_ADD_MEMBERSHIP, mreq)
	mif = IPAddr.new( INTERFACE_ADDR ).hton
	client.setsockopt(Socket::IPPROTO_IP, Socket::IP_MULTICAST_IF, mif)

	sockaddr = Socket.pack_sockaddr_in( TARGET_PORT, MULTICAST_ADDR )
	
	File.open(ARGV[0], "rb") {|f|
		sdata = f.read
		client.send(sdata, 0, sockaddr)
	}

	client.close
end

main()
