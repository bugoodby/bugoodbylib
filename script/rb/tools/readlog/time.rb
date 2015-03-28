#!/usr/bin/ruby
require "optparse"

#-----------------------------------------------------------
# ruby DebugUtil v1
#-----------------------------------------------------------
class DebugUtil
	attr_reader :c; attr_reader :f; attr_reader :ws
	def initialize()
		@c = true; @f = false; @ws = NIL
	end
	def init( target )
		@c = true; @f = false;
		if ( target == "both" ) then @c = true; @f = true
		elsif ( target == "file" ) then @c = false; @f = true end
		if ( @f ) then
			@ws = File.open(File.dirname(File.expand_path($0))+"/debuglog.txt", "a")
			@ws.puts "\n\n\n[[[LOG START]]]"
		end
	end
	def term()
		if ( @ws ) then @ws.close(); @ws = NIL; end
	end
end
$dbgutl = DebugUtil.new()
def LOG( obj )
	if ( $dbgutl.c ) then puts obj end
	if ( $dbgutl.f ) then $dbgutl.ws.puts obj end
end
def LOG_P( obj )
	if ( $dbgutl.c ) then puts obj.inspect end
	if ( $dbgutl.f ) then $dbgutl.ws.puts obj.inspect end
end
def LOG_ARRAY( ary )
	LOG("+-----------------------")
	LOG("| +len = " + ary.length.to_s)
	ary.each_with_index{|p, i|
		LOG("| " + i.to_s + " : " + p.to_s)
	}
	LOG("+-----------------------")
end
#-----------------------------------------------------------

def getTime( line )
	str = "N/A"
	if ( /^\s*([0-9\.]+):/ =~ line )
		str = $1
	end
	return str
end

def getDiff( startStr, endStr )
	startTime = 0; endTime = 0;
	
	toTime = lambda {|s, ms, us|
		return (s.to_i(10) * 1000000) + (ms.to_i(10) * 1000) + us.to_i(10)
	}
	
	if ( startStr == nil || endStr == nil )
		return "N/A"
	end
	if ( /^\s*(\d+)\.(\d+)\.(\d+):/ =~ startStr )
		startTime = toTime.call($1, $2, $3)
	end
	if ( /^\s*(\d+)\.(\d+)\.(\d+):/ =~ endStr )
		endTime = toTime.call($1, $2, $3)
	end
	diffStr = (endTime - startTime).to_s()
	return diffStr
end


class DocDataMgr
	attr_reader :docData
	
	def initialize()
		@docData = Hash::new
	end
	
	def getData( docId )
		if ( !@docData.include?(docId) )
			return nil
		else
			return @docData[docId]
		end
	end
	
	def setData( docId, key, value )
		if ( !@docData.include?(docId) )
			d = { key => value }
			@docData.store(docId, d)
		else
			@docData[docId].store(key, value)
		end
	end
	
	def printResult( docId )
		l = lambda {|d, s, e|
			LOG format("     %-30s - %-30s : %15s - %15s : %15s\n", 
				s, e, getTime(d[s]), getTime(d[e]), getDiff(d[s], d[e]))
		}
		
		d = @docData[docId]
		l.call(d, 'POINT1', 'POINT2')
		l.call(d, 'POINT3', 'POINT4')
		l.call(d, 'hoge', 'POINT2')
		l.call(d, 'POINT2', 'POINT1')
	end
	
	def dump()
		LOG "--------------------------------------------"
		LOG "[DocDataMgr dump]"
		LOG " size = " << @docData.size.to_s
		@docData.each_pair {|docId, d|
			LOG "***"
			LOG "   docId => " << docId
			d.each_pair {|key, val|
				LOG "   " << key << " => " << val
			}
		}
	end
end


class PageDataMgr
	attr_reader :pageData
	
	def initialize()
		@pageData = []
	end
	
	def getData( docId, pageId )
		@pageData.each {|p|
			if ( p['docId'] == docId && p['pageId'] == pageId )
				return p
			end
		}
		return nil
	end
	
	def setData( docId, pageId, key, value )
		p = getData(docId, pageId)
		if ( p == nil )
			p = { 'docId' => docId, 'pageId' => pageId, key => value }
			@pageData.push(p)
		else
			p.store(key, value)
		end
	end
	
	def printResult( docId )
		l = lambda {|p, s, e|
			LOG format("%3d: %-30s - %-30s : %15s - %15s : %15s\n", 
				p['pageId'], s, e, getTime(p[s]), getTime(p[e]), getDiff(p[s], p[e]))
		}
		
		@pageData.each {|p|
			if ( p['docId'] == docId )
				pageId = p['pageId']
				l.call(p, 'POINT1', 'POINT2')
			end
		}
	end
	
	def dump()
		LOG "--------------------------------------------"
		LOG "[PageDataMgr dump]"
		LOG " size = " << @pageData.size.to_s
		@pageData.each {|p|
			LOG "***"
			p.each_pair {|key, val|
				LOG "   " << key << " => " << val
			}
		}
		LOG "--------------------------------------------"
	end
end

class Parser
	def initialize()
		@infile = ""
		@ddm = DocDataMgr.new
		@pdm = PageDataMgr.new
		@current_d = "0"
		@current_p = "0"
	end
	
	def parse( infile )
		@infile = infile
		lines = File.open(infile, "r:UTF-8").grep(/(:HOGE|aiueo\(.+\))/)
		
		lines.each {|line|
			if ( / POINT1/ =~ line )
				@ddm.setData("12345", "POINT1", line)
				@pdm.setData("12345", "1", "POINT1", line)
			elsif ( / POINT2/ =~ line )
				@ddm.setData("12345", "POINT2", line)
				@pdm.setData("12345", "1", "POINT2", line)
			elsif ( / POINT3/ =~ line )
				@ddm.setData("12345", "POINT3", line)
			elsif ( / POINT4/ =~ line )
				@ddm.setData("12345", "POINT4", line)
			else
				#ignore
			end
		}
		output_result()
	end
	
	def output_result()
		LOG "source: " + @infile
		LOG "--------------------------------------------"
		@ddm.docData.each_key {|docId|
			LOG "[docID = " << docId << "]"
			@ddm.printResult(docId)
			@pdm.printResult(docId)
		}
		LOG "\n\n\n"
		
		@ddm.dump()
		@pdm.dump()
	end
end

#---------------------------------------------------------------
# main
#---------------------------------------------------------------
def main() 
	$dbgutl.init("console")
	infile = ""
	outfile = ""
	
	# parse option parameters.
	OptionParser.new("Usage: ruby #{File.basename($0)} [options] <file>") do |opt|
		opt.on('-h', '--help', 'show this message') { puts opt; exit }
		begin
			opt.parse!
		rescue
			puts "Invalid option.\n\n#{opt}"
			exit
		end 
		# check input file.
		if ( ARGV.length == 0 ) then
			puts "Please input file name.\n\n#{opt}"
			exit
		end
		infile = ARGV[0]
	end
	
	if ( !FileTest.readable?(infile) )
		LOG "[ERROR] fail to open: " << infile
		return
	end
	
	p = Parser.new()
	p.parse(infile)
	
	$dbgutl.term()
end

main()

