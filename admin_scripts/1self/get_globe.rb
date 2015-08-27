#!/usr/bin/env ruby

require 'net/http'
require 'json'

def app_key 
  'app-id-9bb5f1c77f0df722a9b1bc650a41988a'
end

def app_secret
  'app-secret-70ddd9b5cd842c9747246a5510d831b0fd18110d9bbb487d3e276f1a1c31b448'
end

def globe_token
  "591ea03f188deb7e2e80977a5b9ca55d9a640e18231ee097af6a65388cd78110"
end

def one_self_base_url
  'https://api.1self.co/v1/apps'
end

address = "#{one_self_base_url}/#{app_key}/events/cyber-dojo/create/.animatedglobe?token=#{globe_token}"
p address
url = URI.parse(address)
req = Net::HTTP::Get.new(url.to_s)
http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true
res = http.request(req) 
p res
p res.body


