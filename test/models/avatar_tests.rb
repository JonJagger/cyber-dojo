require File.dirname(__FILE__) + '/../test_helper'

class AvatarTests < ActionController::TestCase

  def setup
    @kata = make_kata('Ruby-installed-and-working')
  end

  def teardown
    Thread.current[:file] = nil
    system("rm -rf #{root_dir}/katas/*")
    system("rm -rf #{root_dir}/zips/*")    
  end
  
  test "deleted file is deleted from that repo tag" do
    avatar = Avatar.create(@kata, 'wolf')  # creates tag-0
    visible_files = avatar.visible_files
    deleted_filename = 'instructions'
    visible_files[deleted_filename] = 'Whatever'
    
    run_tests(avatar, visible_files)  # creates tag-1
    visible_files.delete(deleted_filename)
    run_tests(avatar, visible_files)  # creates tag-2
    
    before = avatar.visible_files(tag=1)
    assert before.keys.include?("#{deleted_filename}"),
          "before.keys.include?(#{deleted_filename})"
          
    after = avatar.visible_files(tag=2)
    assert !after.keys.include?("#{deleted_filename}"),
          "!after.keys.include?(#{deleted_filename})"
  end
  
  test "diff_lines is not empty when change in files" do
    avatar = Avatar.create(@kata, 'wolf') # 0
    visible_files = avatar.visible_files
    run_tests(avatar, visible_files) # 1
    visible_files['cyber-dojo.sh'] += 'xxxx'
    run_tests(avatar, visible_files) # 2
    traffic_lights = avatar.traffic_lights
    assert_equal 2, traffic_lights.length
    was_tag = nil
    now_tag = nil
    actual = avatar.diff_lines(was_tag = 1, now_tag = 2)    
    assert actual.match(/^diff --git/)
  end

  test "diff_lines shows added file" do
    avatar = Avatar.create(@kata, 'wolf') # 0
    visible_files = avatar.visible_files
    added_filename = 'unforgiven.txt'
    content = 'starring Clint Eastwood'
    visible_files[added_filename] = content
    run_tests(avatar, visible_files) # 1
    actual = avatar.diff_lines(was_tag=0, now_tag=1)
    expected =
      [
        "diff --git a/sandbox/#{added_filename} b/sandbox/#{added_filename}",
        "new file mode 100644",
        "index 0000000..1bdc268",
        "--- /dev/null",
        "+++ b/sandbox/#{added_filename}",
        "@@ -0,0 +1 @@",
        "+starring Clint Eastwood"
      ].join("\n")
    assert actual.include?(expected)
  end

  test "diff_lines shows deleted file" do
    avatar = Avatar.create(@kata, 'wolf') # 0
    visible_files = avatar.visible_files
    deleted_filename = 'instructions'
    content = 'tweedle_dee'
    visible_files[deleted_filename] = content
    run_tests(avatar, visible_files)  # 1
    visible_files.delete(deleted_filename)    
    run_tests(avatar, visible_files)  # 2
    actual = avatar.diff_lines(was_tag=1, now_tag=2)
    expected =
      [
        "diff --git a/sandbox/#{deleted_filename} b/sandbox/#{deleted_filename}",
        "deleted file mode 100644",
        "index f68a37c..0000000",
        "--- a/sandbox/#{deleted_filename}",
        "+++ /dev/null",
        "@@ -1 +0,0 @@",
        "-#{content}"       
      ].join("\n")
    assert actual.include?(expected)
  end

end
