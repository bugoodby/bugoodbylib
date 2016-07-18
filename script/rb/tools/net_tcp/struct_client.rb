require 'socket'

#--------------------------------
# test struct
#
#<send>
# - item1   : 1byte
# - item2   : 2bytes
# - item3   : 4bytes
# - len     : 4bytes
# - msg     : variable length
#
#<replay>
# - len1     : 4bytes
# - msg1    : variable length
# - len2     : 4bytes
# - msg2    : variable length
#--------------------------------

def dumpbin( f, data )
	dumpLine = lambda {|d, o|
		chars = ""
		line = sprintf("0x%08X: ", o)
		d.each_byte do |bytedata|
			line << sprintf("%02X ", bytedata)
			chars << ((bytedata >= 0x20 && bytedata <= 0x7e) ? bytedata.chr : '.')
		end
		line << "   " * (16 - d.length)
		return (line + " " + chars + "\n")
	}
	offset = 0
	while d = data[offset, 16]
		f.print dumpLine.call(d, offset)
		offset += 16
	end
end


def packTestStruct( src = {} )
	data = ''
	data << Array(src[:item1]).pack('C');
	data << Array(src[:item2]).pack('n');
	data << Array(src[:item3]).pack('N');
	data << Array(src[:msg].length).pack('N');
	data << src[:msg]
	return data
end

def unpackTestStructReply( src )
	data = {}
	offset = 0
	data[:len1] = src[offset, 4].unpack('N')[0]
	offset += 4
	data[:msg1] = src[offset, data[:len1]]
	offset += data[:len1]
	data[:len2] = src[offset, 4].unpack('N')[0]
	offset += 4
	data[:msg2] = src[offset, data[:len2]]
	return data
end


def main() 

	if ARGV.length == 0
		puts "usage: #{File.basename($0)} <ip addr> <port num>"
		exit
	end
	
	puts "*** tcp client ***"
	puts "  ip addr = " + ARGV[0]
	puts "  port    = " + ARGV[1]
	
	client = TCPSocket.open(ARGV[0], ARGV[1].to_i)
	
	info = {
		:item1 => 123,
		:item2 => 0xABCD,
		:item3 => 0x12345678,
		:msg   => "This is a test message.",
	}
	d = packTestStruct(info)
	client.write(d)
	client.flush
	
	puts '...wait reply...'
	
	buf = client.recv(65536)
	dumpbin(STDOUT, buf)
	p unpackTestStructReply(buf)
	
	client.close
end

main()
