require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/mock_disk_file'

class ExerciseTests < ActionController::TestCase
  
  def setup
    @mock_file = MockDiskFile.new
    Thread.current[:file] = @mock_file
    @exercise = Exercise.new(root_dir, 'Yahtzee')
  end
  
  def teardown
    Thread.current[:file] = nil
  end
    
  test "dir is based on name" do
    assert @exercise.dir.match(@exercise.name), @exercise.dir
    assert !@mock_file.called?
  end
  
  test "dir does not end in a slash" do
    assert !@exercise.dir.end_with?(File::SEPARATOR),
          "!#{@exercise.dir}.end_with?(#{File::SEPARATOR})"
    assert !@mock_file.called?
  end
  
  test "dir does not have doubled separator" do
    doubled_separator = File::SEPARATOR + File::SEPARATOR
    assert_equal 0, @exercise.dir.scan(doubled_separator).length
    assert !@mock_file.called?
  end
  
  test "name is as set in ctor" do
    assert_equal 'Yahtzee', @exercise.name
    assert !@mock_file.called?
  end

  test "instructions are loaded" do
    @mock_file.setup(
      [ 'Fishing on the Verdal' ]
    )
    instructions = @exercise.instructions
    assert @mock_file.called?
    assert_not_nil instructions
    assert instructions.start_with? "Fishing on the Verdal"
  end
  
end
