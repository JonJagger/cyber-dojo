require_relative '../test_helper'

class IntegrationTest < ActionController::IntegrationTest

  def setup
    # calls test_helper's ActiveSupport::TestCase::setup
    # (from test_helper) which does `rm -rf #{root_path}/katas/*`
    super
    # used in application_controller.root_path()
    ENV['CYBERDOJO_TEST_ROOT_DIR'] = 'true'
  end

  def json
    ActiveSupport::JSON.decode @response.body
  end

  def html
    @response.body
  end

  def checked_save_id
    # currently does not set Thread.current[:disk] etc
    post 'setup/save',
      :language => 'Ruby-installed-and-working',
      :exercise => 'test_Yahtzee'

    json['id']
  end

end
