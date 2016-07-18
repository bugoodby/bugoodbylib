#!/bin/ruby
require 'open3'

#-----------------------
# console
#-----------------------
puts "=========================================="
puts "*** system ***"
p system("echo hoge")
puts "=> status: #{$?}"

puts "*** back quote ***"
p `echo hoge`
puts "=> status: #{$?}"

puts "*** Open3.capture3 ***"
out, err, status = Open3.capture3("echo hoge", :stdin_data=>"")
p out
p err
p status


#-----------------------
# gui
#-----------------------
puts "=========================================="
puts "*** system ***"
p system("notepad")
puts "=> status: #{$?}"

puts "*** back quote ***"
p `notepad`
puts "=> status: #{$?}"

puts "*** Open3.capture3 ***"
out, err, status = Open3.capture3("notepad", :stdin_data=>"foo\nbar\nbaz\n")
p out
p err
p status

puts "*** spawn ***"
p spawn("notepad")

