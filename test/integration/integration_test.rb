require File.dirname(__FILE__) + '/../test_helper'

class IntegrationTest  < ActionController::IntegrationTest

  def checked_save_id
    post 'dojo/save', rooted({
      :name => 'jj-101',
      :language => 'C assert',
      :exercise => 'Yahtzee'
    })
    assert_match @response.redirect_url, /^#{url_for :action => 'index', :controller => 'dojo'}/
    @response.redirect_url =~ /id=(.+)/ or fail "Unexpected #{@response.redirect_url}"
    $1
  end
  
  def avatar_from_response
    raw_redirect = @response.header["Location"]
    assert_match raw_redirect, /avatar=.../
    pattern = Regexp.new('avatar=(.*)')
    pattern.match(raw_redirect)[1]
  end
  
  def rooted(hash)
    hash[:root_dir] = root_dir
    hash
  end
  
  def xroot_dir
    Rails.root + 'test/cyberdojo'
  end
  
end
