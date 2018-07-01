
#! /usr/bin/env ruby
#http://notetoself.vrensk.com/2008/09/verified-https-in-ruby/

require 'net/https'
require 'uri'

def makeRequest(string)
  string = makeHTTPSFromPath(string)
  uri = URI.parse(string)
  begin
    request(uri)
  rescue Exception => e 
    puts e
  end
end
def makeHTTPSFromPath(string)
  "https://" +string + "/"
end
def request(uri)
  puts "attempting request to #{uri}"
  http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true 
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      http.ca_file = File.join(File.dirname(__FILE__), "cacert.pem")
      http.start {
        http.request_get(uri.path) {|res|
          print res.body
          puts "\n\nfrom request to #{uri}, (uri.scheme =#{uri.scheme})"
        }
      }
end

def run()
  if (ARGV[0])
    makeRequest(ARGV[0])
  end
  while(true)
    puts "\n\n\nenter the request url (format: domain.path)\n"
    input = STDIN.gets.chomp
    makeRequest(input)
  end
end

run()




