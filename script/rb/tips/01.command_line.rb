#!/bin/ruby

#-----------------------------------------------------------
# main
#-----------------------------------------------------------
def main()
	
	puts "count = " << ARGV.length.to_s
	
	puts "--- method 1 ---\n"
	for arg in ARGV
		p arg
	end
	
	puts "--- method 2 ---\n"
	ARGV.each {|arg|
		p arg
	}
	
	puts "--- method 3 ---\n"
	ARGV.each_with_index {|arg, i|
		puts i.to_s << " : " << arg
	}
	
	puts "--- method 4 ---\n"
	i = 0
	while i < ARGV.length
		print i.to_s + " : " + ARGV[i] + "\n"
		i = i + 1
	end
	
end


main()
