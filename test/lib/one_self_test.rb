#!/usr/bin/env ../test_wrapper.sh lib

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

  # - - - - - - - - - - - - - - - - - 
  
  test 'created' do
    http_requester = OneSelfHttpRequesterStub.new
    one_self = OneSelf.new(disk, http_requester)
    kata = make_kata  
    language_name,test_name = kata.language.display_name.split(',').map{|s| s.strip }      
    hash = {
      :kata_id => kata.id,
      :language_name => language_name,
      :test_name => test_name,
      :latitude => '51.0190',
      :longtitude => '3.1000'
    }
    one_self.created(hash)
    
    assert_equal 'api.1self.co', http_requester.spied_url_hosts[0]
  end
  
  # - - - - - - - - - - - - - - - - - 

  test 'started' do
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

  test 'tested' do
    kata = make_kata        
    lion = kata.start_avatar(['lion'])
    http_requester = OneSelfHttpRequesterStub.new    
    one_self = OneSelf.new(disk, http_requester)            
    
    disk[lion.path].write(one_self.manifest_filename, started_manifest)        
    hash = {     
      :tag => 1,
      :colour => 'red',
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
    assert_equal '#F00', properties['color']
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
