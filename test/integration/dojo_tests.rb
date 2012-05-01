require File.dirname(__FILE__) + '/../test_helper'
require './integration_test'

class DojoControllerTest  < IntegrationTest

  test "index" do
    get 'dojo/index'
    assert_response :success
  end
  
  test "dojo full" do
    id = checked_save_id
    post 'dojo/full', rooted({ :id => id })    
    assert_response :success, @response.body
  end
  
  test "dojo cant find kata from id" do
    bad_id = 'ab00ab11ab'
    post 'dojo/cant_find', rooted({ :id => bad_id })    
    assert_response :success, @response.body
  end
  
  test "create" do
    get 'dojo/create'
    assert_response :success
  end

  test "save" do
    checked_save_id
  end
  
  test "start-coding redirects to cant-find for invalid kata-id" do
    bad_id = 'ab00ab11ab'
    post 'dojo/start', rooted({ :id => bad_id })
    assert_redirected_to "/dojo/cant_find?id=#{bad_id}"
    #assert_response :success    
  end

  test "start-coding succeeds for valid kata-id" do
    id = checked_save_id
    post 'dojo/start', rooted({ :id => id })
    avatar = avatar_from_response
    assert_redirected_to :controller => 'kata', :action => 'edit', :id => id, :avatar => avatar
  end
   
  test "start-coding succeeds once for each avatar name, then dojo is full" do
    id = checked_save_id
    (1..Avatar.names.length).each do |n|
      post 'dojo/start', rooted({ :id => id })
      avatar = avatar_from_response
      assert_redirected_to :controller => 'kata', :action => 'edit', :id => id, :avatar => avatar
    end
    post 'dojo/start', rooted({ :id => id })
    assert_redirected_to "/dojo/full?id=#{id}"
  end
    
    
  test "faqs,links,tips,why" do
    post 'dojo/faqs'
    assert_response :success
    post 'dojo/links'
    assert_response :success
    post 'dojo/tips'
    assert_response :success
    post 'dojo/why'
    assert_response :success
  end
  
end
