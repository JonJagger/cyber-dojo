# See comments at end of file

require 'net/http'
require 'uri'
require 'json'

class OneSelf
    
  def initialize(disk, requester = HttpRequester.new)
    @disk,@requester = disk,requester
  end
  
  def created(hash)
    data = {
      'objectTags' => [ 'cyber-dojo' ],
      'actionTags' => [ 'create' ],
      'dateTime' => server_time(hash[:now]),      
      'location' => { 
        'lat'  => hash[:latitude], 
        'long' => hash[:longtitude] 
      },
      'properties' => {
        'dojo-id' => hash[:kata_id],
        'exercise-name' => hash[:exercise_name],
        'language-name' => hash[:language_name],
        'test-name'     => hash[:test_name]
      }
    }
    url = URI.parse("#{streams_url}/#{stream_id}/events")    
    request = Net::HTTP::Post.new(url.path, json_header(write_token))
    request.body = data.to_json
    http_response(url.host, request)    
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def started(avatar)
    url = URI.parse(streams_url)
    request = Net::HTTP::Post.new(url.path, json_header("#{app_key}:#{app_secret}"))
    response = http_response(url.host, request)    
    body =  JSON.parse(response.body)
    one_self = {
      :stream_id   => body['streamid'],
      :read_token  => body['readToken'],
      :write_token => body['writeToken']
    }
    @disk[avatar.path].write(manifest_filename, one_self)
  end
  
  # - - - - - - - - - - - - - - - - - - - - - -
  
  def tested(avatar,hash)
    # tags belonging to 1self are camelCase
    # tags belonging to me (in properties) are dash-separated    
    data = {
      'objectTags' => [ 'cyber-dojo' ],
      'actionTags' => [ 'test-run' ],
      'dateTime' => server_time(hash[:now]),
      'properties' => {
        'dojo-id' => avatar.kata.id,
        'avatar' => avatar.name,
        'tag' => hash[:tag],
        'color' => css(hash[:colour]),
        'added-line-count' => hash[:added_line_count],
        'deleted-line-count' => hash[:deleted_line_count],
        'seconds-since-last-test' => hash[:seconds_since_last_test],
      }
    }
    one_self = JSON.parse(@disk[avatar.path].read(manifest_filename))    
    url = URI.parse("#{streams_url}/#{one_self['stream_id']}/events")
    request = Net::HTTP::Post.new(url.path, json_header("#{one_self['write_token']}"))
    request.body = data.to_json
    http_response(url.host, request)
  end
  
  # - - - - - - - - - - - - - - - - - - - - - -
  
  def manifest_filename
    '1self_manifest.json'    
  end
  
private
  
  def server_time(now)
    s = Time.mktime(*now).utc.iso8601.to_s
    # eg 2015-06-25T09:11:15Z
    # the offset to local time is now known (yet)
    # this is represented by removing the Z and adding -00:00
    s[0..-2] + "-00:00"
  end
  
  def http_response(url_host, req)
    @requester.request(url_host, req)
  end  
  
  def css(colour)
    return '#F00' if colour === 'red'
    return '#FF0' if colour === 'amber'
    return '#0F0' if colour === 'green'
    return '#C0C0C0' # timed__out -> 'gray'
  end
  
  def streams_url
    'https://api.1self.co/v1/streams'
  end

  def json_header(authorization)
    { 'Content-Type' =>'application/json', 'Authorization' => authorization }
  end
    
  # below need to come from ENV[]
  
  def app_key 
    'app-id-9bb5f1c77f0df722a9b1bc650a41988a'
  end
  
  def app_secret
    'app-secret-70ddd9b5cd842c9747246a5510d831b0fd18110d9bbb487d3e276f1a1c31b448'
  end
  
  def stream_id
    'GSYZNQSYANLMWEEH'
  end
  
  #def read_token
  #  '474f621260b2f9e5b6f6025cd5eea836b362b0bf1bfa'
  #end
  
  def write_token
    'ddbc8384eaf4b6f0e70d66b606ccbf7ad4bb22bfe113'
  end
  
end


# Would it be possible to issue an http post containing json in bash?
# http://stackoverflow.com/questions/14978411/http-post-and-get-using-curl-in-linux/14978657#14978657
