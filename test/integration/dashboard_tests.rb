require File.dirname(__FILE__) + '/../test_helper'

class DashboardControllerTest < ActionController::IntegrationTest

  test "show no avatars" do
    id = checked_save_id
    get "/dashboard/show", rooted({ :id => id })
    assert_response :success    
  end
  
  test "show avatars but no traffic-lights" do
    id = checked_save_id
    (1..4).each do |n|
      post '/dojo/start', rooted({ :id => id })
      avatar = avatar_from_response
      assert_redirected_to "/kata/edit?id=#{id}&avatar=#{avatar}"      
    end
    get "dashboard/show", rooted({ :id => id })
    assert_response :success    
  end  
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  def checked_save_id
    post 'dojo/save', rooted({
      :name => 'jj-101',
      :language => 'C assert',
      :exercise => 'Yahtzee'
    })
    redirect =  @response.redirected_to
    assert_not_nil redirect
    assert_equal Hash, redirect.class
    id = redirect[:id]
    assert_not_nil id
    assert_redirected_to "/dojo/index/#{id}"
    id
  end
  
  def avatar_from_response
    raw_redirect = @response.header["Location"]    
    pattern = Regexp.new('avatar=(.*)')
    pattern.match(raw_redirect)[1]
  end
  
  def rooted(hash)
    hash[:root_dir] = RAILS_ROOT + '/test/cyberdojo'
    hash
  end
  
end

