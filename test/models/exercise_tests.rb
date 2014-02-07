require File.dirname(__FILE__) + '/../coverage_test_helper'
require File.dirname(__FILE__) + '/stub_disk_file'

class ExerciseTests < ActionController::TestCase
    
  def setup
    Thread.current[:file] = @stub_file = StubDiskFile.new  
    @exercise = Exercise.new(root_dir, 'Yahtzee')
  end
  
  def teardown
    Thread.current[:file] = nil
  end
    
  test "name is as set in ctor" do
    assert_equal 'Yahtzee', @exercise.name
  end
    
  test "dir is based on name" do
    assert @exercise.dir.match(@exercise.name), @exercise.dir
  end
  
  test "dir does not end in a slash" do
    assert !@exercise.dir.end_with?(@stub_file.separator),
          "!#{@exercise.dir}.end_with?(#{@stub_file.separator})"
  end
  
  test "dir does not have doubled separator" do
    doubled_separator = @stub_file.separator * 2
    assert_equal 0, @exercise.dir.scan(doubled_separator).length
  end
  
  test "instructions are loaded" do
    @stub_file.read=({
      :dir => @exercise.dir,
      :filename => 'instructions',
      :content => 'Fishing on the Verdal'
    })    
    instructions = @exercise.instructions
    assert_not_nil instructions
    assert instructions.start_with? "Fishing on the Verdal"
  end

end
