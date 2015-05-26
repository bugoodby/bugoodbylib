require 'uri'
require 'net/http'

def http_request(method, uri, query_hash={})
	query = query_hash.map{|k, v| "#{k}=#{v}"}.join('&')
	query_escaped = URI.escape(query)

	uri_parsed = URI.parse(uri)
	http = Net::HTTP.new(uri_parsed.host)

	case method.downcase!
	when 'get'
		return http.get(uri_parsed.path + '?' + query_escaped)
	when 'post'
		return http.post(uri_parsed.path, query_escaped)
	end
end

res = http_request('POST', 'https://www.google.com/cloudprint/search', {})
puts res.code
puts res.message
puts res.body
