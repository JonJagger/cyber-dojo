require File.dirname(__FILE__) + '/../test_helper'
#require 'Uuid'

class IntegrationTest  < ActionController::IntegrationTest

  def setup
    ENV['CYBERDOJO_TEST_ROOT_DIR'] = 'true'    
  end
  
  def teardown
    system("rm -rf #{root_dir}/katas/*")
    system("rm -rf #{root_dir}/zips/*")
  end
  
  def json
    ActiveSupport::JSON.decode @response.body
  end

  def checked_save_id
    language = Language.new(root_dir, 'Ruby-installed-and-working')
    exercise = Exercise.new(root_dir, 'Yahtzee')
    info = { 
      :created => make_time(Time.now),
      :id => Uuid.new.to_s,
      :browser => 'Firefox',
      :language => language.name,
      :exercise => exercise.name,
      :visible_files => language.visible_files,
      :unit_test_framework => language.unit_test_framework,
      :tab_size => language.tab_size
    }
    info[:visible_files]['output'] = ''
    info[:visible_files]['instructions'] = 'practice'
    
    kata = Kata.create(root_dir, info)
    kata.id
  end
    
  def quoted(filename)
    "'" + filename + "'"
  end
end
