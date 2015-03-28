#!/bin/ruby
require 'win32ole'
require "fileutils"

def method1()
	$unzipApp = "C:\\Program Files (x86)\\Lhaca\\Lhaca.exe"
	$scriptDir = File.dirname(File.expand_path($0))
	
	cmd = "\"" + $unzipApp + "\" \"" + ARGV[0] + "\""
	puts cmd
	p system(cmd)
end

def method2( src, dst )
	FileUtils.mkdir_p(dst)
	if ( File.exists?(dst) ) then
		objShell = WIN32OLE.new("Shell.Application")
		objZip = objShell.NameSpace(src)
		objZip.Items().each {|item|
			objShell.Namespace(dst).CopyHere(item)
		}
		return true
	end
	return false
end

def method3( src, dst )
	cmd = "rundll32.exe zipfldr.dll,RouteTheCall \"" + src + "\""
	puts cmd
	p system(cmd)
end

dst = File.dirname(ARGV[0]) + "\\" + File.basename(ARGV[0], File.extname(ARGV[0]))
puts dst
#Dir::mkdir(dst) if ( !File.exists?(dst) )
method3(ARGV[0], dst)

