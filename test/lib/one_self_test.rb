#!/usr/bin/env ../test_wrapper.sh lib

require_relative 'lib_test_base'

class HttpRequesterStub

  def initialize
    @stubbed,@spied = [],[]
    @index = 0
  end

  attr_reader :spied
  
  def stub(response)
    @stubbed << response
  end
  
  def request(url_host, _req)
    @spied << url_host
    stub = @stubbed[@index]
    @index += 1
    stub
  end

end

# - - - - - - - - - - - - - - - - - - -

class HttpResponseStub

  def initialize(streamId,readToken,writeToken)
    @streamId,@readToken,@writeToken = streamId,readToken,writeToken
  end

  def body
    JSON.unparse({
      'streamid' => @streamId,
      'readToken' => @readToken,
      'writeToken' => @writeToken
    })
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
    http_requester = HttpRequesterStub.new
    one_self = OneSelf.new(disk, http_requester)
    kata = make_kata  
      
    latitude = '51.0190'
    longtitude = '3.1000'
    one_self.created(kata,latitude,longtitude)
    
    assert_equal 'api.1self.co', http_requester.spied[0]
  end
  
  # - - - - - - - - - - - - - - - - - 

  test 'started' do
    kata = make_kata        
    lion = kata.start_avatar(['lion'])
    http_requester = HttpRequesterStub.new
    one_self = OneSelf.new(disk, http_requester)    
    streamId = 'PIVYWTZNMXVQXRCW'
    readToken = '5ae66388fd84d955240b2628dae09d4614bb70b8dfd4'
    writeToken = '91680d93e8707257ace629e3645b0181dc8938775fe9'
    http_requester.stub(HttpResponseStub.new(streamId,readToken,writeToken))
    
    one_self.started(lion)
    
    assert_equal 'api.1self.co', http_requester.spied[0]
    data = JSON.parse(disk[lion.path].read(one_self.manifest_filename))
    assert_equal streamId, data['stream_id']
    assert_equal readToken, data['read_token']
    assert_equal writeToken, data['write_token']
  end
  
  # - - - - - - - - - - - - - - - - - 

=begin
  test 'tested' do
    kata = make_kata        
    lion = kata.start_avatar(['lion'])
    http_requester = HttpRequesterStub.new
    one_self = OneSelf.new(disk, http_requester)    
    #...      
    one_self.tested(lion,tag=1,colour='red',now=Time.now)
    #...
  end    
=end
      
end
