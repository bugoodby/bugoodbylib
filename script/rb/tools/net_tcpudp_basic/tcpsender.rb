#!/usr/bin/ruby
require "socket"

def main() 

	if ARGV.length == 0
		puts "usage: #{File.basename($0)} <ip addr> <port num> <file>"
		exit
	end
	
	puts "*** tcp client ***"
	puts "  ip addr = " + ARGV[0]
	puts "  port    = " + ARGV[1]
	puts "  data    = " + ARGV[2]
	
	client = TCPSocket.open(ARGV[0], ARGV[1].to_i)

	File.open(ARGV[2], "rb") {|f|
		sdata = f.read
		client.write(sdata)
	}

	client.close
end

main()
