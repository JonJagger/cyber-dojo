require File.dirname(__FILE__) + '/../test_helper'

class IntegrationTest  < ActionController::IntegrationTest

  def setup
    ENV['CYBERDOJO_TEST_ROOT_DIR'] = 'true'    
  end
  
  def json
    ActiveSupport::JSON.decode @response.body
  end

  def checked_save_id
    post 'setup/save', {
      :language => 'Ruby-installed-and-working',
      :exercise => 'Yahtzee'
    }
    assert_match @response.redirect_url, /^#{url_for :action => 'index', :controller => 'dojo'}/
    @response.redirect_url =~ /id=(.+)/ or fail "Unexpected #{@response.redirect_url}"
    $1
  end
    
  def quoted(filename)
    "'" + filename + "'"
  end
end
