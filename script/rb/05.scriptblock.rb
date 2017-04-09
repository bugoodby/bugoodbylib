#!/bin/ruby

def func( str1, str2 )
	puts "func( #{str1}, #{str2} )"
end

scriptBlock = lambda {|str1, str2|
	puts "scriptBlock( #{str1}, #{str2} )"
}

puts "*** func ***"
func( "aaa", "bbb" )

puts "*** script block ***"
scriptBlock.call( "aaa", "bbb" )

