require File.dirname(__FILE__) + '/../test_helper'
require 'avatar'
require 'DateTimeExtensions'


class AutoPostMessageTests < ActionController::TestCase

  Root_test_folder = RAILS_ROOT + '/test/test_dojos'

  def root_test_folder_reset
    system("rm -rf #{Root_test_folder}")
    Dir.mkdir Root_test_folder
  end

  def make_params
    { :dojo_name => 'Jon Jagger', 
      :dojo_root => Root_test_folder,
      :filesets_root => RAILS_ROOT +  '/filesets',
      'kata' => 'Unsplice (*)',
      'language' => 'C++',
      :browser => 'None (test)'
    }
  end
  
  def create_avatar
    root_test_folder_reset
    assert Dojo::create(make_params)
    Dojo::configure(make_params)    
    dojo = Dojo.new(make_params)
    dojo.create_avatar
  end
  
  def test_increment_queries
    assert Increment.new({:outcome => :passed}).passed?
    assert !Increment.new({:outcome => :failed}).passed?
  end

  def test_first_test_passing
    avatar = create_avatar
    assert !avatar.just_passed_first_test?(Increment.all([{:outcome => :failed}]))
    assert avatar.just_passed_first_test?(Increment.all([{:outcome => :failed},{:outcome=>:passed}]))
    assert !avatar.just_passed_first_test?(Increment.all([{:outcome => :passed},{:outcome=>:passed}]))
  end
  
  def test_refactoring_streak
    avatar = create_avatar
    assert !avatar.refactoring_streak?(Increment.all([]))    
    no_streak = [{:outcome => :passed}] * 4 
    assert !avatar.refactoring_streak?(Increment.all(no_streak))
    streak = [{:outcome => :passed}] * 5
    assert avatar.refactoring_streak?(Increment.all(streak))
    no_new_streak = [{:outcome => :passed}] * 6
    assert !avatar.refactoring_streak?(Increment.all(no_new_streak))
    new_streak = [{:outcome => :passed}] * 10
    assert avatar.refactoring_streak?(Increment.all(new_streak))
    
    interrupted_streak = [
      {:outcome => :passed},
      {:outcome => :passed},
      {:outcome => :failed},
      {:outcome => :passed},
      {:outcome => :passed},
      {:outcome => :passed},
      ]
      assert !avatar.refactoring_streak?(Increment.all(interrupted_streak))      
  end
  
  def test_reluctant_to_run_tests
    avatar = create_avatar
    assert !avatar.reluctant_to_run_tests?(Increment.all([]), [])
    recent_run = [ {:time => 11.minutes.ago.to_a}, {:time => 9.minutes.ago.to_a }]
    assert !avatar.reluctant_to_run_tests?(Increment.all(recent_run), [])
    reluctant_run = [ {:time => 12.minutes.ago.to_a}, {:time => 11.minutes.ago.to_a }]
    assert avatar.reluctant_to_run_tests?(Increment.all(reluctant_run), [])
  end
  
  def test_dont_send_reluctance_message_if_already_sent
    avatar = create_avatar
    reluctant_run = Increment.all([{:time => 11.minutes.ago.to_a }])
    messages_containing_reluctance = [{:sender => avatar.name, :type => :test_reluctance, :created => 1.minute.ago.to_a}]
    assert !avatar.reluctant_to_run_tests?(reluctant_run, messages_containing_reluctance)
  end
  
  def test_do_send_reluctance_message_if_message_is_not_regarding_reluctance
    avatar = create_avatar
    reluctant_run = Increment.all([{:time => 11.minutes.ago.to_a }])
    irrelevant_messages = [{:sender => avatar.name, :type => nil, :created => 1.minute.ago.to_a}]
    assert avatar.reluctant_to_run_tests?(reluctant_run, irrelevant_messages)
  end

  def test_do_send_reluctance_message_if_message_regards_different_avatar
    avatar = create_avatar
    reluctant_run = Increment.all([{:time => 11.minutes.ago.to_a }])
    irrelevant_messages = [{:sender => "somebody else", :type => :test_reluctance, :created => 1.minute.ago.to_a}]
    assert avatar.reluctant_to_run_tests?(reluctant_run, irrelevant_messages)
  end
  
  def test_do_send_reluctance_message_if_last_message_was_10_minutes_ago
    avatar = create_avatar
    reluctant_run = Increment.all([{:time => 11.minutes.ago.to_a }])
    irrelevant_messages = [{:sender => avatar.name, :type => :test_reluctance, :created => 11.minute.ago.to_a}]
    assert avatar.reluctant_to_run_tests?(reluctant_run, irrelevant_messages)
  end
  
end
