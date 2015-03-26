#!/usr/bin/env ruby

require 'net/http'
require 'json'

def one_self_base_url
  'https://api.1self.co/v1/apps'
end

def json_header(authorization)
  { 'Content-Type' =>'application/json', 'Authorization' => authorization }
end

def app_key 
  'app-id-9bb5f1c77f0df722a9b1bc650a41988a'
end

def app_secret
  'app-secret-70ddd9b5cd842c9747246a5510d831b0fd18110d9bbb487d3e276f1a1c31b448'
end

url = URI.parse("#{one_self_base_url}/#{app_key}/token")
request = Net::HTTP::Post.new(url.path, json_header("Basic #{app_key}:#{app_secret}"))
data = {
  "objectTags" => ["cyber-dojo"],
  "actionTags" => ["create"],
  "location" => true
}
request.body = data.to_json
http = Net::HTTP.new(url.host)
response = http.request(request) 
p response
p response.body


