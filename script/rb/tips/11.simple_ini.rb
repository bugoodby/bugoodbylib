#!/bin/ruby

def read_ini( inipath )
	inidata = {}
	File.open(inipath, "r") {|f|
		while line = f.gets
			line.strip!
			next if (line.length == 0 || line[0] == ';')
			inidata[$1.strip] = $2.strip if ( line =~ /^(.+)=(.*)/ )
		end
	}
	return inidata
end


path = File.join( File.dirname(File.expand_path($0)), "test.ini")
p read_ini(path)

