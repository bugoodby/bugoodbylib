#!/bin/ruby

root2 =  ARGV[0].gsub("\\", "/")
puts root2

puts "=== all ==="
Dir.glob(root2 + "/*") {|f|
	if ( File.directory?(f) )
		print "dir : "
		puts f
	else
		print "file: "
		puts f
	end
}

puts "=== all(recursive) ==="
Dir.glob(root2 + "/**/*") {|f|
	if ( File.directory?(f) )
		print "dir : "
		puts f
	else
		print "file: "
		puts f
	end
}

puts "=== text(recursive) ==="
Dir.glob(root2 + "/**/*.txt") {|f|
	if ( File.directory?(f) )
		print "dir : "
		puts f
	else
		print "file: "
		puts f
	end
}

puts "=== Folder ==="
Dir.glob(root2 + "/*/") {|f|
	if ( File.directory?(f) )
		print "dir : "
		puts File.basename(f)
	else
		print "file: "
		puts f
	end
}

