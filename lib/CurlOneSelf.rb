
# Quick look at replacing Net::HTTP::Post calls with bash curl calls

#require 'net/http'
#require 'uri'
require 'json'
require 'open4'

write_token = 'ddbc8384eaf4b6f0e70d66b606ccbf7ad4bb22bfe113'

def json_header
  { 'Content-Type' =>'application/json', 'Authorization' => write_token }
end

data = {
      'objectTags' => [ 'cyber-dojo' ],
      'actionTags' => [ 'create' ],
      'dateTime' => '2015-06-25T09:11:15-00:00',
      'location' => { 
        'lat'  => 'LAT', # ??
        'long' => 'LONG' # ??
      },
      'properties' => {
        'dojo-id' => '96DA91B46B',
        'exercise-name' => 'Fizz_Buzz',
        'language-name' => 'C#',
        'test-name'     => 'NUnit'
      }
}

streams_url = 'https://api.1self.co/v1/streams'
stream_id = 'GSYZNQSYANLMWEEH'

# Using Net::HTTP::Post
#
#url = URI.parse("#{streams_url}/#{stream_id}/events")    
#request = Net::HTTP::Post.new(url.path, json_header)
#request.body = data.to_json
#result = Net::HTTP.new(url.host).request(request)
#p result


curl = 'curl' +
  ' --silent' +
  ' --header content-type:application/json' + 
  " --header authorization:#{write_token}" +
  ' -X POST' +
  " -d '#{data.to_json}'" +
  " #{streams_url}/#{stream_id}/events"

p curl

# Using backtick
#
#output = `#{curl} &`
#es = $?.exitstatus    
#p es if es != 0
#p output if output != ""

# Using Process::spawn
#
#http://ujihisa.blogspot.co.uk/2010/03/how-to-run-external-command.html
#pid = Process::spawn(curl)
#Process::wait(pid)
#p $?


# Using Open4
#https://github.com/ahoward/open4

#pid,stdin,stdout,stderr = Open4::popen4 curl
#_,status = Process::waitpid2 pid

status = Open4::popen4(curl) do |_pid,stdin,stdout,stderr|
  p '<STDOUT>'
  p stdout.read.strip
  p '<STDERR>'
  p stderr.read.strip
end
p '<STATUS>'
p status.exitstatus

  

