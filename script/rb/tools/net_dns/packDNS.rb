#!/usr/bin/ruby

def packDNS( infile )
	data = ""
	
	File.open(infile, "r") {|f|
		inRDATA = false
		rdata = ""
		inTEXT = false
		dataTXT = ""
		
		while line = f.gets
			line.strip!
			if ( line[0] == "#" )
				print "SKIP: " + line + "\n"
				next
			end
			if ( /^<RDATA>/ =~ line )
				inRDATA = true
				next
			end
			if ( /^<\/RDATA>/ =~ line )
				inRDATA = false
				data += Array( rdata.length ).pack("n*")
				data += rdata
				rdata = ""
				next
			end
			if ( /^<RDATA TXT>/ =~ line )
				inTEXT = true
				next
			end
			if ( /^<\/RDATA TXT>/ =~ line )
				inTEXT = false
				data += Array( dataTXT.length ).pack("n*")
				data += dataTXT
				next
			end
			
			if ( inTEXT )
				p "TXT: " + line
				dataTXT += Array( line.length ).pack("C*")
				dataTXT += line
			else
				line.scan(/^(\S+)\s+(\S+)\s*=\s*(.+)/) {|a|
					packed_data = ""
					case a[0]
					when "BYTE"
						radix = ( a[2].include?("0x") ) ? 16 : 10;
						packed_data += Array(a[2].to_i(radix)).pack("C*")
					when "WORD"
						radix = ( a[2].include?("0x") ) ? 16 : 10;
						packed_data += Array(a[2].to_i(radix)).pack("n*")
					when "DWORD"
						radix = ( a[2].include?("0x") ) ? 16 : 10;
						packed_data += Array(a[2].to_i(radix)).pack("N*")
					when "LABEL"
						label = ""
						domains = a[2].split(".")
						domains.each {|d|
							label += Array(d.length).pack("C*")
							label += d
						}
						label += "\000"
						packed_data += label
					when "IPv4"
						packed_data += a[2].split(".").collect{|c| c.to_i}.pack("C4")
					when "DUMP"
						packed_data += Array(a[2][0, 48].delete(' ')).pack("H*")
					else
						print "[ERROR] unknown type: " + a[0] + "\n"
					end
					
					if ( inRDATA )
						rdata += packed_data
					else
						data += packed_data
					end
				}
			end
		end
	}
	
	return data
end

def usage
	puts "Usage: #{File.basename($0)} <file>"
end

if ARGV.length == 0
	usage()
	exit
end

infile = ARGV[0]
outfile = infile.sub(/\.[^.]+$/, ".bin")

data = packDNS(infile)

of = File.open(outfile, "wb")
of.write(data)
of.close()

