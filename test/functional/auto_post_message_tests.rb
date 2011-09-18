require File.dirname(__FILE__) + '/../test_helper'
require 'avatar'


class AutoPostMessageTests < ActionController::TestCase

  #def just_passed_first_test(increments)
  #  increments.count { |inc| inc[:outcome] == :passed } == 1 and increments.last[:outcome] == :passed
  #end
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
  
end
