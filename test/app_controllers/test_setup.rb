#!/usr/bin/env ruby

require_relative '../test_helper'
require_relative 'integration_test'

class SetupControllerTest  < IntegrationTest

  test 'show' do
    get 'setup/show'
    assert_response :success
  end

  #- - - - - - - - - - - - - - - - - - -

=begin
  test 'setup/shows language of exercise of kata whose id is passed' do
    # setup_dojo
    # create kata
    # gets its id

    # get 'setup/show', :id => id

    # assert json parameters

  end
=end

  #- - - - - - - - - - - - - - - - - - -

  test 'save' do
    checked_save_id
  end

  #- - - - - - - - - - - - - - - - - - -

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

end
