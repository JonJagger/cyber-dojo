
require 'net/http'
require 'uri'
require 'json'

class OneSelf
    
  def initialize(disk)
    @disk = disk
  end
  
  def created(kata,latitude,longtitude)
    language_name,test_name = kata.language.display_name.split(',').map{|s| s.strip }
    data = {
      'objectTags' => [ 'cyber-dojo' ],
      'actionTags' => [ 'create' ],
      'location' => { 'lat' => latitude, 'long' => longtitude },
      'properties' => {
        'dojo-id' => kata.id,
        'language-name' => language_name,
        'test-name' => test_name
      }
    }
    url = URI.parse("#{streams_url}/#{stream_id}/events")
    request = Net::HTTP::Post.new(url.path, json_header(write_token))
    request.body = data.to_json
    http = Net::HTTP.new(url.host)
    response = http.request(request) 
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def started(avatar)
    url = URI.parse(streams_url)
    request = Net::HTTP::Post.new(url.path, json_header("#{app_key}:#{app_secret}"))
    http = Net::HTTP.new(url.host)
    body =  JSON.parse(http.request(request).body)
    one_self = {
      :stream_id => body['streamid'],
      :read_token => body['readToken'],
      :write_token => body['writeToken']
    }
    @disk[avatar.path].write(one_self_manifest_filename, one_self)     
  end
  
  # - - - - - - - - - - - - - - - - - - - - - -
  
  def tested(avatar,tag,colour,now)
    added_line_count,deleted_line_count = line_counts(avatar.diff(tag-1,tag))
    data = {
      'objectTags' => [ 'cyber-dojo' ],
      'actionTags' => [ 'test-run' ],
      'dateTime' => Time.mktime(*now).utc.iso8601.to_s,
      'properties' => {
        'color' => css(colour),
        'added-line-count' => added_line_count,
        'deleted-line-count' => deleted_line_count,
        #'seconds-since-last-test' => 
        'dojo-id' => avatar.kata.id,
        'avatar' => avatar.name
      }
    }
    one_self = JSON.parse(@disk[avatar.path].read(one_self_manifest_filename))    
    url = URI.parse("#{streams_url}/#{one_self['stream_id']}/events")
    http = Net::HTTP.new(url.host)
    request = Net::HTTP::Post.new(url.path, json_header("#{one_self['write_token']}"))
    request.body = data.to_json
    response = http.request(request)
  end
  
private
  
  def css(colour)
    return '#F00' if colour === 'red'
    return '#FF0' if colour === 'amber'
    return '#0F0' if colour === 'green'
    return '#C0C0C0' # timed__out -> 'gray'
  end
  
  # copy-pasted from app/helpers/tip_helper.rb
  def line_counts(diffed_files)
    added_count,deleted_count = 0,0
    diffed_files.each do |filename,diff|
      if filename != 'output'
        added_count   += diff.count { |line| line[:type] == :added   }
        deleted_count += diff.count { |line| line[:type] == :deleted }
      end
    end
    [added_count,deleted_count]
  end

  def streams_url
    'https://api.1self.co/v1/streams'
  end

  def one_self_manifest_filename
    '1self_manifest.json'    
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
  
  def read_token
    '474f621260b2f9e5b6f6025cd5eea836b362b0bf1bfa'
  end
  
  def write_token
    'ddbc8384eaf4b6f0e70d66b606ccbf7ad4bb22bfe113'
  end
  
end
