#!/bin/ruby

#-----------------------------------------------------------
# main
#-----------------------------------------------------------
def main()
	infile = ARGV[0]
	
	if ( !FileTest.readable?(infile) )
		puts "[ERROR] fail to open: " << infile
		return
	end
	
	File.open(infile, "r") {|f|
		while line = f.gets
			puts line
		end
	}
	
	#文字コードを指定して読み込み
	f = File.open(infile, "r:UTF-8")
	f.each {|line|
		puts line
	}
	f.close
	
	#ファイルの内容をgrep
	lines = open(infile).grep(/^#/)
	lines.each {|line|
		puts line
	}
end


main()
