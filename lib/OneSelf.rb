
class OneSelf
    
  def created(dojo_id,latitude,longtitude)
    data = {
      'objectTags' => [ 'cyber-dojo' ],
      'actionTags' => [ 'create' ],
      'location' => { 'lat' => latitude, 'long' => longtitude },
      'properties' => { 'dojoId' => dojo_id }
    }
    url = URI.parse("#{streams_url}/#{stream_id}/events")
    request = Net::HTTP::Post.new(url.path, json_header("#{write_token}"))
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
    disk[avatar.path].write(one_self_manifest_filename, one_self)     
  end
  
  # - - - - - - - - - - - - - - - - - - - - - -
  
  def tested(avatar,tag,colour)  
    added_line_count,deleted_line_count = line_counts(avatar.diff(tag-1,tag))
    diff_line_count = added_line_count + deleted_line_count
    data = {
      'objectTags' => [ 'cyber-dojo' ],
      'actionTags' => [ 'test-run' ],
      'properties' => {
        'color' => colour,
        'diffCount' => diff_line_count,
        'dojoId' => avatar.kata.id,
        'avatar' => avatar.name
      }
    }
    one_self = JSON.parse(disk[avatar.path].read(one_self_manifest_filename))    
    url = URI.parse("#{streams_url}/#{one_self['stream_id']}/events")
    http = Net::HTTP.new(url.host)
    request = Net::HTTP::Post.new(url.path, json_header("#{one_self['write_token']}"))
    request.body = data.to_json
    response = http.request(request)
  end
  
private
  
  include ExternalDiskDir
  
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
    
  # below are temporary, need to come from ENV[]
  
  def app_key 
    'app-id-9bb5f1c77f0df722a9b1bc650a41988a'
  end
  
  def app_secret
    'app-secret-70ddd9b5cd842c9747246a5510d831b0fd18110d9bbb487d3e276f1a1c31b448'
  end
  
  def stream_id
    'PUXUNZEGWRZUWYRG'
  end
  
  def read_token
    '62713acce800c7bcd75829d16a8aa3e2fb9f2d2daeb0'
  end
  
  def write_token
    'c705e320fd8b9591d27d9579f78fad6ab3a7c0f86078'
  end
  
end
