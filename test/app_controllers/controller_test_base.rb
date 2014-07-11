require_relative '../test_helper'
require '../lib/SpyDisk'
require '../lib/SpyGit'
require '../lib/StubTestRunner'

class ControllerTestBase < ActionController::IntegrationTest

  def setup
    # calls test_helper's ActiveSupport::TestCase::setup
    # (from test_helper) which does `rm -rf #{root_path}/katas/*`
    super
    # used in application_controller.root_path()
    ENV['CYBERDOJO_TEST_ROOT_DIR'] = 'true'
  end

  def thread
    Thread.current
  end

  def setup_dojo
    externals = {
      :disk   => @disk   = thread[:disk  ] = SpyDisk.new,
      :git    => @git    = thread[:git   ] = SpyGit.new,
      :runner => @runner = thread[:runner] = StubTestRunner.new
    }
    @dojo = Dojo.new(root_path,externals)
  end

  def teardown
    thread[:disk] = nil
    thread[:git] = nil
    thread[:runner] = nil
    #TODO: @disk.teardown
    #TODO: @git.teardown
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
