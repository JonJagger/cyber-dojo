#!/bin/bash ../test_wrapper.sh

require_relative 'AppControllerTestBase'

class ExceptionControllerTests < AppControllerTestBase

  def setup
    @consider = Rails.application.config.consider_all_requests_local
    @show = Rails.application.config.action_dispatch.show_exceptions
    Rails.application.config.consider_all_requests_local = false
    Rails.application.config.action_dispatch.show_exceptions = true
  end

  def teardown
    Rails.application.config.consider_all_requests_local = @consider
    Rails.application.config.action_dispatch.show_exceptions = @show
  end

=begin
  # these pass when run
  #   $./test_exception.rb
  # but not when run
  #   ./run_all.sh 
  # ??

  test "bad path" do
    get 'dojo/sdsdsd'
    assert_template 'error/sorry'
  end

  test "bad id" do
    get 'kata/edit/234523424234'
    assert_template 'error/sorry'
  end
=end

end
