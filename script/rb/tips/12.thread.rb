#!/bin/ruby

t1 = Thread.new do
	begin
		puts "timer thread start"
		loop do
			puts "  timer start"
			sleep 5
			puts "  timeout"
			system("echo hoge")
		end
	ensure
		puts "timer thread end"
	end
end

t2 = Thread.new do
	begin
		puts "worker thread start"
		system("notepad")
		puts "worker thread end"
	rescue
	end
end
t2.join

t1.kill if t1.alive?
t1.join

puts "finished"

