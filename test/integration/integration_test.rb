require File.dirname(__FILE__) + '/../test_helper'

class IntegrationTest  < ActionController::IntegrationTest

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
    hash[:root_dir] = root_dir
    hash
  end
  
  def root_dir
    RAILS_ROOT + '/test/cyberdojo'
  end
  
end
