require File.dirname(__FILE__) + '/../test_helper'

class DojoControllerTest  < ActionController::TestCase

  def test_index
    get :index
    assert_response :success
  end
  
  test "create" do
    get :create
    assert_response :success
  end

  test "save" do
    checked_save_id
  end
  
  test "cant start coding if given kata-id does not exist" do
    bad_id = 'ab00ab11ab'
    post :start, rooted({ :id => bad_id })
    assert_redirected_to "/dojo/cant_find?id=#{bad_id}"
  end

  test "start coding succeeds" do
    id = checked_save_id
    post :start, rooted({ :id => id })
    avatar = avatar_from_response
    assert_redirected_to "/kata/edit?id=#{id}&avatar=#{avatar}"
  end
    
  test "start coding succeeds once for each avatar name, then dojo is full" do
    id = checked_save_id
    (1..Avatar.names.length).each do |n|
      post :start, rooted({ :id => id })
      avatar = avatar_from_response
      assert_redirected_to "/kata/edit?id=#{id}&avatar=#{avatar}"      
    end
    post :start, rooted({ :id => id })
    assert_redirected_to "/dojo/full?id=#{id}"
  end
  
  test "faqs,links,tips,why" do
    post :faqs
    assert_response :success
    post :links
    assert_response :success
    post :tips
    assert_response :success
    post :why
    assert_response :success
  end
  
  def checked_save_id
    post :save, rooted({
      :root_dir => RAILS_ROOT + '/test/cyberdojo',
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
