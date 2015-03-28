#!/bin/ruby
require 'net/http'
Net::HTTP.version_1_2
require 'open-uri'

def usage
	prog = __FILE__
	puts "Usage: #{prog} <URL>"
	exit 1
end

def LOG( s )
	puts s
end

def getHttpFile( url, dst )
	LOG("*** HTTP GET : " + url + " ==> " + dst)
	u = URI.parse(url)
	res = Net::HTTP.get(u.host, u.path)
	open(dst, "w+b") do |o|
		o.print res
	end
end

# use basic authentication
def getHttpFile2( url, dst )
	user    = "user"
	pass    = "pass"
	
	url2 = url.sub(/^http[s]*:\/\//, "http://")
	
	LOG("*** HTTP GET : " + url2 + " ==> " + dst)
	open(url2, :http_basic_authentication => [user, pass]) do |source|
		open(dst, "w+b") do |o|
			o.print source.read
		end
	end
end

# user basic authentication ( target and proxy )
def getHttpFile3( url, dst )
	user    = "user"
	pass    = "pass"
	pxy     = "http://my.proxy.com:8080"
	pxy_usr = "proxyuser"
	pxy_pss = "proxypass"
	
	url2 = url.sub(/^http[s]*:\/\//, "http://")
	
	options = {
		:proxy_http_basic_authentication => [pxy, pxy_usr, pxy_pss],
		:http_basic_authentication => [user, pass]
	}
	
	LOG("*** HTTP GET : " + url2 + " ==> " + dst)
	open(url2, options) do |source|
		open(dst, "w+b") do |o|
			o.print source.read
		end
	end
end


url = ARGV.shift
usage unless url

begin
	output = File.join(File.dirname(File.expand_path($0)), "out1.txt")
	getHttpFile(url, output)
rescue
	LOG("[exception] #{$!.message}")
end

begin
	output = File.join(File.dirname(File.expand_path($0)), "out2.txt")
	getHttpFile2(url, output)
rescue
	LOG("[exception] #{$!.message}")
end

begin
	output = File.join(File.dirname(File.expand_path($0)), "out3.txt")
	getHttpFile3(url, output)
rescue
	LOG("[exception] #{$!.message}")
end

