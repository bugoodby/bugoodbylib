#!/bin/ruby

#-----------------------------------------------------------
# main
#-----------------------------------------------------------
def main()
	
	p 123.class
	p "hoge".class
	p [1, 2, 3].class
	p 3.14.class
	p 100000000000000000.class
	
	p "--------------------------------"

	File.open("04.class.rb", "r") {|f|
		line = f.gets
		line.strip!
		p line
		data = Array(line).pack("H*")
		p data
		p data.class
	}

	p "--------------------------------"

	str = "69 73 20 70 72 6F 67 72 61 6D 20 63 61 6E 6E 6F"
	p str
	dat = Array(str.delete(' ')).pack("H*")
	p dat
	p dat.class
	str2 = dat.unpack("H*")
	p str2
	p str2.class
	p str2[0].class

	p "--------------------------------"

	"hoge".bytes {|b| 
		p b
		p b.to_s(16)
		p b.class
	}

	p "hoge".bytes.collect {|b| b.to_s(16) }.join(" ")

end


main()
