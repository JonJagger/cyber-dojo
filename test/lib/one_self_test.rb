#!/bin/bash ../test_wrapper.sh

require_relative 'lib_test_base'

class OneSelfHttpRequesterStub

  def initialize
    @spied_url_hosts,@spied_requests = [],[]
    @stubbed = []
    @index = 0
  end

  attr_reader :spied_url_hosts
  attr_reader :spied_requests
  
  def stub(response)
    @stubbed << response
  end
  
  def request(url_host, req)
    @spied_url_hosts << url_host
    @spied_requests << req
    stub = @stubbed[@index]
    @index += 1
    stub
  end

end

# - - - - - - - - - - - - - - - - - - -

class OneSelfHttpResponseStub

  def initialize(manifest)
    @manifest = manifest
  end

  def body
    JSON.unparse(@manifest)
  end
  
end

# - - - - - - - - - - - - - - - - - - -

class OneSelfTests < LibTestBase

  def setup
    super
    set_disk_class_name     'DiskStub'    
    set_git_class_name      'GitSpy'        
    set_one_self_class_name 'OneSelfDummy'
    # important to use OneSelfDummy because
    # creating a new kata calls dojo.one_self.created
  end

  include TimeNow
  
  # - - - - - - - - - - - - - - - - - 
  
  test 'http requester' do
    requester = HttpRequester.new
    url = URI.parse('http://www.google.co.uk')
    req = Net::HTTP::Get.new('#q=cyber-dojo')
    response = requester.request(url.host, req)
    assert response.to_s.start_with? '#<Net::HTTPFound'
  end
    
  # - - - - - - - - - - - - - - - - - 
  
  test 'kata created' do
    http_requester = OneSelfHttpRequesterStub.new
    one_self = OneSelf.new(disk, http_requester)
    kata = make_kata  
    exercise_name = kata.exercise.name
    language_name,test_name = kata.language.display_name.split(',').map{|s| s.strip }      
    hash = {
      :now => time_now,
      :kata_id => kata.id,
      :exercise_name => exercise_name,
      :language_name => language_name,
      :test_name     => test_name,
      :latitude   => '51.0190',
      :longtitude => '3.1000'
    }
    one_self.created(hash)
    
    assert_equal 'api.1self.co', http_requester.spied_url_hosts[0]    
    body = JSON.parse(http_requester.spied_requests[0].body)
    assert_equal ['cyber-dojo'], body['objectTags']
    assert_equal ['create'], body['actionTags']
    location = body['location']
    assert_equal hash[:latitude], location['lat']
    assert_equal hash[:longtitude], location['long']
    properties = body['properties']
    assert_equal kata.id, properties['dojo-id']
    assert_equal language_name, properties['language-name']
    assert_equal test_name, properties['test-name']
    assert_equal kata.exercise.name, properties['exercise-name']
  end
  
  # - - - - - - - - - - - - - - - - - 

  test 'avatar started' do
    kata = make_kata        
    lion = kata.start_avatar(['lion'])
    http_requester = OneSelfHttpRequesterStub.new
    one_self = OneSelf.new(disk, http_requester)    
    
    http_requester.stub(OneSelfHttpResponseStub.new(started_manifest))    
    one_self.started(lion)
    
    assert_equal 'api.1self.co', http_requester.spied_url_hosts[0]
    data = JSON.parse(disk[lion.path].read(one_self.manifest_filename))
    assert_equal streamId, data['stream_id']
    assert_equal readToken, data['read_token']
    assert_equal writeToken, data['write_token']
  end
  
  # - - - - - - - - - - - - - - - - - 

  test 'tests run' do
    light_colour('red',  '#F00')
    light_colour('amber','#FF0')
    light_colour('green','#0F0')
    light_colour('timed_out','#C0C0C0')
  end
  
  # - - - - - - - - - - - - - - - - - 

  def light_colour(colour,css)
    kata = make_kata        
    lion = kata.start_avatar(['lion'])
    http_requester = OneSelfHttpRequesterStub.new    
    one_self = OneSelf.new(disk, http_requester)            
    
    disk[lion.path].write(one_self.manifest_filename, started_manifest)        
    hash = {     
      :tag => 1,
      :colour => colour,
      :now => Time.now,
      :added_line_count => 2,
      :deleted_line_count => 6,
      :seconds_since_last_test => 45
    }
    one_self.tested(lion,hash)

    data = JSON.parse(http_requester.spied_requests[0].body)
    assert_equal ['cyber-dojo'], data['objectTags']
    assert_equal ['test-run'], data['actionTags']
    properties = data['properties']
    assert_equal kata.id, properties['dojo-id']
    assert_equal 'lion', properties['avatar']
    assert_equal hash[:tag], properties['tag']
    assert_equal css, properties['color']
    assert_equal hash[:added_line_count], properties['added-line-count']
    assert_equal hash[:deleted_line_count], properties['deleted-line-count']
    assert_equal hash[:seconds_since_last_test], properties['seconds-since-last-test']
  end    
      
  # - - - - - - - - - - - - - - - - - 
  
  def started_manifest    
    { 
      'streamid' => streamId,
      'readToken' => readToken,
      'writeToken' => writeToken
    }
  end
  
  def streamId
    'PIVYWTZNMXVQXRCW'
  end
  
  def readToken
    '5ae66388fd84d955240b2628dae09d4614bb70b8dfd4'
  end
  
  def writeToken
    '91680d93e8707257ace629e3645b0181dc8938775fe9'
  end
      
end
