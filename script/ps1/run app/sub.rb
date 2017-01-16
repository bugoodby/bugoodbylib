#!/usr/bin/ruby
# -*- coding: utf-8 -*-

ARGV.each_with_index {|arg, i|
	puts i.to_s << " : " << arg
}

puts "sub.rb start"
sleep(5)
puts "sub.rb end"

exit 5
