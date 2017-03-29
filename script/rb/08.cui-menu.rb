#!/usr/bin/ruby

def getInputString1()
	print 'INPUT: '
	input = STDIN.gets.chomp.downcase
	puts "  INPUT: #{input}"
end

def getInputString2()
	list = [ "One", "Two", "Three", "four", "five" ]
	list.each_with_index {|s, i|
		puts "#{i+1} : #{s}"
	}
	puts "q : quit"
	
	print 'Select number: '
	input = STDIN.gets.chomp.downcase
	return if ( input == 'q' )
	
	num = input.to_i - 1
	if ( num == 0 || num > list.length )
		puts "[ERROR] Invalid range."
		return
	end

	puts "  INPUT: #{input} ==> #{list[num]}"
end

def getInputString3()
	list = []
	path = File.join( File.dirname(File.expand_path($0)), '08.list.txt')
	if ( FileTest.readable?(path) )
		File.open(path, "r:UTF-8") {|f|
			while line = f.gets
				line.strip!
				next if (line.length == 0 || line[0] == '#')
				list << line
			end
		}
	end
	list.each_with_index {|s, i|
		puts "#{i+1} : #{s}"
	}
	puts "q : quit"
	
	print 'Select number: '
	input = STDIN.gets.chomp.downcase
	return if ( input == 'q' )
	
	num = input.to_i - 1
	if ( num == 0 || num > list.length )
		puts "[ERROR] Invalid range."
		return
	end

	puts "  INPUT: #{input} ==> #{list[num]}"
end

loop do
	puts '----------------------------------------'
	puts '[0] getInputString1'
	puts '[1] getInputString2'
	puts '[2] getInputString3'
	puts '[q] quit'
	puts '----------------------------------------'
	print "number: "
	response = STDIN.gets.chomp.downcase
	exit if ( response == 'q' )

	case response
	when '0' then
		getInputString1
	when '1' then
		getInputString2
	when '2' then
		getInputString3
	else
		puts '[ERROR] invalid number.'
	end
	
	
	print 'repeat? (y/n): '
	answer = STDIN.gets.chomp.downcase
	if ( answer != 'y' )
		break
	end
end

