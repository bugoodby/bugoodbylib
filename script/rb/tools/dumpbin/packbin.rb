#!/usr/bin/ruby

def packbin( infile, outfile )
	of = File.open(outfile, "wb")
	
	File.open(infile, "r") {|f|
		while line = f.gets
			line.strip!
			if ( line[0] == "#" )
				print "SKIP: " + line + "\n"
				next
			end
			a = line.split(/\s*:\s*/)
			if ( a.length >= 2 )
				of.write( Array(a[1][0, 48].delete(' ')).pack("H*") )
			end
		end
	}
	
	of.close()
end

def usage
	puts "usage: #{File.basename($0)} <file>"
end

if ARGV.length == 0
	usage()
	exit
end

infile = ARGV[0]
outfile = infile.sub(/\.[^.]+$/, ".bin")
packbin(infile, outfile)


