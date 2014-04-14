require File.dirname(__FILE__) + '/../test_helper'
require 'OsDisk'

class OsDiskTests < ActionController::TestCase

  def setup
    super
    Thread.current[:disk] = @disk = OsDisk.new
    @dir = root_path + 'tmp/'
    `rm -rf #{@dir}`
    `mkdir -p #{@dir}`
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "[dir] always has path ending in /" do
    assert_equal "ABC/", @disk['ABC'].path
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "exists?(dir) false when dir does not exist, true when it does" do
    `rm -rf #{@dir}`
    assert !@disk[@dir].exists?
    @disk[@dir].make
    assert @disk[@dir].exists?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "exists?(filename) false when file exists, true when it does" do
    `rm -rf #{@dir}`
    filename = 'hello.txt'
    assert !@disk[@dir].exists?(filename)
    @disk[@dir].write(filename, "content")
    assert @disk[@dir].exists?(filename)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "reads back what was written" do
    expected = "content"
    @disk[@dir].write('filename', expected)
    actual = @disk[@dir].read('filename')
    assert_equal expected, actual
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "on_lock_if_path_does_not_exist_exception_is_thrown_block_is_not_executed_and_result_is_nil" do
    block_run = false
    exception_throw = false
    begin
      result = @disk.lock('dir_does_not_exist') do
        block_run = true
      end
    rescue
      exception_thrown = true
    end

    assert exception_thrown
    assert !block_run
    assert_nil result
  end

  test "if_lock_is_obtained_block_is_executed_and_result_is_result_of_block" do
    block_run = false
    begin
      result = @disk[@dir].lock {
        block_run = true; 'Hello'
      }
      assert block_run, 'block_run'
      assert_equal 'Hello', result
    end
  end

  test "outer_lock_is_blocking_so_inner_lock_blocks" do
    outer_run = false
    inner_run = false
    @disk[@dir].lock do
      outer_run = true

      inner_thread = Thread.new {
        @disk[@dir].lock do
          inner_run = true
        end
      }
      max_seconds = 2
      result = inner_thread.join(max_seconds);
      timed_out = (result == nil)
      if inner_thread != nil
        Thread.kill(inner_thread)
      end
    end
    assert outer_run
    assert !inner_run
  end

  test "holding_lock_on_parent_dir_does_not_prevent_acquisition_of_lock_on_child_dir" do
    parent_dir = @dir + 'parent' + @disk.dir_separator
    child_dir = parent_dir + 'child' + @disk.dir_separator
    `mkdir #{parent_dir}`
    `mkdir #{child_dir}`
    parent_run = false
    child_run = false
    @disk[parent_dir].lock do
      parent_run = true
      @disk[child_dir].lock do
        child_run = true
      end
    end
    assert parent_run
    assert child_run
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "symlink" do
    expected = "content"
    @disk[@dir].write('filename', expected)
    oldname = @dir + 'filename'
    newname = @dir + 'linked'
    output = @disk.symlink(oldname, newname)
    assert !File.symlink?(oldname)
    assert File.symlink?(newname)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "save_file (rb) for non-string is saved as inspected object and folder is automatically created" do
    object = { :a => 1, :b => 2 }
    check_save_file('manifest.rb', object, "{:a=>1, :b=>2}")
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "save_file (json) for non-string is saved as JSON object and folder is automatically created" do
    object = { :a => 1, :b => 2 }
    check_save_file('manifest.json', object, '{"a":1,"b":2}')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "save_file for string - folder is automatically created" do
    object = "hello world"
    check_save_file('manifest.rb', object, "hello world")
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "saving a file with a folder creates the subfolder and the file in it" do
    pathed_filename = 'f1/f2/wibble.txt'
    content = 'Hello world'
    @disk[@dir].write(pathed_filename, content)

    full_pathed_filename = @dir + pathed_filename
    assert File.exists?(full_pathed_filename),
          "File.exists?(#{full_pathed_filename})"
    assert_equal content, IO.read(full_pathed_filename)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "save file for non executable file" do
    check_save_file('file.a', 'content', 'content')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "save file for executable file" do
    check_save_file('file.sh', 'ls', 'ls', executable=true)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "save filename longer than but ends in makefile is not auto-tabbed" do
    content = '    abc'
    expected_content = content
    check_save_file('smakefile', content, expected_content)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def check_save_file(filename, content, expected_content, executable = false)
    @disk[@dir].write(filename, content)
    pathed_filename = @dir + filename
    assert File.exists?(pathed_filename),
          "File.exists?(#{pathed_filename})"
    assert_equal expected_content, IO.read(pathed_filename)
    assert_equal executable, File.executable?(pathed_filename),
                            "File.executable?(pathed_filename)"
  end

end
