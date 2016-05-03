#!/usr/bin/ruby
# -*- coding: utf-8 -*-
require "socket"
require "ipaddr"
require "yaml"


if ARGV.length == 0
	puts "usage: #{File.basename($0)} <port num>"
	exit
end

puts "*********** tcp server start (" + ARGV[0] + ") ***********"
server = TCPServer.open("0.0.0.0", ARGV[0].to_i)
begin
	loop {
		sock = server.accept
		puts "<accept>====================="
		p sock.peeraddr
		p sock.addr
		
=begin
		data = ""
		while buf = sock.gets
			puts "<recv> " + buf.size.to_s
			data += buf
		end
=end
		data = sock.recv(65536)
		puts "<recv> " + data.size.to_s
		j = YAML.parse(data)
		p j
		result = `osascript ./airprint.scpt "#{j['tag']}" "#{j['data']}" "#{j['printer']}" "#{j['psize']}" "#{j['ori']}" "#{j['staple']}" "#{j['punch']}"`
		sock.write(result)
		sock.close
		puts "<close>====================="
	}
rescue Interrupt
	puts "Ctl+C!"
ensure
end

server.close

