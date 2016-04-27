#!/usr/bin/ruby
# -*- coding: utf-8 -*-
require "socket"
require "json"

if ARGV.length == 0
	puts "usage: #{File.basename($0)} <ip addr> <port num> <file>"
	exit
end

puts "*** tcp client ***"
puts "  ip addr = " + ARGV[0]
puts "  port    = " + ARGV[1]
puts "  data    = " + ARGV[2]


TCPSocket.open(ARGV[0], ARGV[1].to_i) {|client|
	# req
	File.open(ARGV[2], "rb") {|f|
		send_data = f.read
		client.write(send_data)
	}
	client.flush

	# ack
	recv_data = client.recv(65536)
	j = JSON.parse(recv_data)
	p j
}

