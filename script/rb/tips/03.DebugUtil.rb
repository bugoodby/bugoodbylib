#!/bin/ruby

#-----------------------------------------------------------
# ruby DebugUtil v2
#-----------------------------------------------------------
class DebugUtil
	attr_reader :c; attr_reader :f; attr_reader :ws
	def initialize()
		@c = true; @f = false; @ws = nil
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
		if ( @ws ) then @ws.close(); @ws = nil; end
	end
end
$dbgutl = DebugUtil.new()
def LOG( obj )
	puts obj if ( $dbgutl.c )
	$dbgutl.ws.puts obj if ( $dbgutl.f )
end
def LOG_P( obj )
	puts obj.inspect if ( $dbgutl.c )
	$dbgutl.ws.puts obj.inspect if ( $dbgutl.f )
end
def LOG_ARRAY( ary )
	LOG("+-----------------------")
	LOG("| len = " + ary.length.to_s)
	ary.each_with_index{|p, i|
		LOG("| " + i.to_s + " : " + p.to_s)
	}
	LOG("+-----------------------")
end
#-----------------------------------------------------------

def LOG_OBJ( obj )
	LOG("| object type = " << obj.class.to_s)
end

#-----------------------------------------------------------
# main
#-----------------------------------------------------------
def main()
	$dbgutl.init("both")
	LOG("************ test START ************")
	
	h = {
		4649 => "yoroshiku",
		5963 => "gokurosan",
		184 => "iyayo",
	}
	a = [
		"apple",
		"orange",
		"grape",
		"melon"
	]
	
	LOG("==== test LOG ====")
	LOG("1 + 1 = " + (1+1).to_s)
	LOG(a)
	LOG(h)
	
	LOG("==== test LOG_P ====")
	LOG_P("1 + 1 = " + (1+1).to_s)
	LOG_P(a)
	LOG_P(h)
	
	LOG("==== test LOG_ARRAY ====")
	LOG_ARRAY(a)
	LOG_ARRAY(h)
	
	LOG("==== test LOG_OBJ ====")
	LOG_OBJ(1)
	LOG_OBJ("string")
	LOG_OBJ(a)
	LOG_OBJ(h)
	
	LOG("************ test END ************")
	$dbgutl.term()
end


main()
