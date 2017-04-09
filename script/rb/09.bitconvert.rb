#!/usr/bin/ruby

def convertValueToBytes( type, val )
	if ( val.index('0x') == 0 )
		base = 16
	else
		base = 10
	end
	
	case type
	when "i8"
		n = val.to_i(base)
		ret = [n].pack("c")
	when "u8"
		n = val.to_i(base)
		ret = [n].pack("C")
	when "i16"
		n = val.to_i(base)
		ret = [n].pack("s>") # big endian
	when "u16"
		n = val.to_i(base)
		ret = [n].pack("n") # big endian
	when "i32"
		n = val.to_i(base)
		ret = [n].pack("l>") # big endian
	when "u32"
		n = val.to_i(base)
		ret = [n].pack("N") # big endian
	when "str"
		ret = val.dup
	else
		ret = nil
	end
	p ret
	return ret
end

def convertBytesToValue( type, bytes )
	case type
	when "i8"
		ret = bytes.unpack("c")[0]
	when "u8"
		ret = bytes.unpack("C")[0]
	when "i16"
		ret = bytes.unpack("s>")[0] # big endian
	when "u16"
		ret = bytes.unpack("n")[0] # big endian
	when "i32"
		ret = bytes.unpack("l>")[0] # big endian
	when "u32"
		ret = bytes.unpack("N")[0] # big endian
	when "str"
		ret = bytes.dup
	else
		ret = nil
	end
	return ret
end

def check( v, b, a )
	puts "#{v.class} : #{v}"
	puts "#{a.class} : #{a}"
	if ( v == a.to_s )
		puts "OK"
	else
		puts "**NG**"
		STDIN.gets
	end
end



v = "-128"
b = convertValueToBytes("i8", v)
a = convertBytesToValue("i8", b)
check(v, b, a)

v = "255"
b = convertValueToBytes("u8", v)
a = convertBytesToValue("u8", b)
check(v, b, a)

v = "-32768"
b = convertValueToBytes("i16", v)
a = convertBytesToValue("i16", b)
check(v, b, a)

v = "65535"
b = convertValueToBytes("u16", v)
a = convertBytesToValue("u16", b)
check(v, b, a)

v = "-2147483648"
b = convertValueToBytes("i32", v)
a = convertBytesToValue("i32", b)
check(v, b, a)

v = "4294967295"
b = convertValueToBytes("u32", v)
a = convertBytesToValue("u32", b)
check(v, b, a)

v = "abcXYZ123 +-*/="
b = convertValueToBytes("str", v)
a = convertBytesToValue("str", b)
check(v, b, a)

