require_relative '../test_helper'

class IntegrationTest  < ActionController::IntegrationTest

  def setup
    super  # calls test_helper's ActiveSupport::TestCase::setup
    ENV['CYBERDOJO_TEST_ROOT_DIR'] = 'true'
  end

  def json
    ActiveSupport::JSON.decode @response.body
  end

  def checked_save_id
    post 'setup/save',
      :language => 'Ruby-installed-and-working',
      :exercise => 'test_Yahtzee'

    json['id']
  end

end
