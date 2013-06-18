require File.dirname(__FILE__) + '/../test_helper'

class AvatarTests < ActionController::TestCase

  def language
    'Ruby-installed-and-working'
  end
  
  test "tag 0 repo contains an empty output file" do
    kata = make_kata(language)
    avatar = Avatar.new(kata, 'wolf') 
    visible_files = avatar.visible_files
    assert visible_files.keys.include?('output'),
          "visible_files.keys.include?('output')"
    assert_equal "", visible_files['output']
  end

  test "there are no increment-traffic-lights before first test-run" do
    kata = make_kata(language)
    avatar = Avatar.new(kata, 'wolf')
    assert_equal [ ], avatar.increments    
  end
  
  test "after avatar is created sandbox contains visible_files" do
    kata = make_kata(language)
    avatar = Avatar.new(kata, 'wolf')    
    avatar.visible_files.each do |filename,_content|
      pathed_filename = avatar.dir + '/sandbox/' + filename
      assert File.exists?(pathed_filename),
            "File.exists?(#{pathed_filename})"      
    end    
  end
  
  test "after avatar is created sandbox contains cyber-dojo.sh and it has execute permission" do
    kata = make_kata(language)
    avatar = Avatar.new(kata, 'wolf')
    cyber_dojo_sh = avatar.dir + '/sandbox/cyber-dojo.sh'
    assert File.exists?(cyber_dojo_sh),
          "File.exists?(#{cyber_dojo_sh})"
    assert File.stat(cyber_dojo_sh).executable?,
          "File.stat(#{cyber_dojo_sh}).executable?"
  end
  
  test "after first test-run increments contains one traffic-light which does not contain output" do
    kata = make_kata(language)
    avatar = Avatar.new(kata, 'wolf')    
    run_tests(avatar, avatar.visible_files)
    increments = avatar.increments
    assert_equal 1, increments.length
    assert_equal nil, increments.last[:run_tests_output]
  end
  
  test "deleted file is deleted from that repo tag" do
    kata = make_kata(language)
    avatar = Avatar.new(kata, 'wolf')  # creates tag-0
    visible_files = avatar.visible_files
    deleted_filename = 'instructions'
    visible_files[deleted_filename] = 'Whatever'
    
    run_tests(avatar, visible_files)  # creates tag-1
    visible_files.delete(deleted_filename)
    run_tests(avatar, visible_files)  # creates tag-2
    
    before = avatar.visible_files(1)
    assert before.keys.include?("#{deleted_filename}"),
          "before.keys.include?(#{deleted_filename})"
          
    after = avatar.visible_files(2)
    assert !after.keys.include?("#{deleted_filename}"),
          "!after.keys.include?(#{deleted_filename})"
  end
  
  test "avatar returns kata it was created with" do
    kata = make_kata(language)
    avatar = Avatar.new(kata, 'wolf')    
    assert_equal kata, avatar.kata    
  end
  
  test "diff_lines is not empty when change in files" do
    kata = make_kata(language)
    avatar = Avatar.new(kata, 'wolf')
    visible_files = avatar.visible_files
    run_tests(avatar, visible_files)
    visible_files['cyber-dojo.sh'] += 'xxxx'
    run_tests(avatar, visible_files)
    increments = avatar.increments
    assert_equal 2, increments.length
    was_tag = nil
    now_tag = nil
    actual = avatar.diff_lines(was_tag = 1, now_tag = 2)    
    assert actual.match(/^diff --git/)
  end

  test "diff_lines shows added file" do
    kata = make_kata(language)
    avatar = Avatar.new(kata, 'wolf') # 0
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
    kata = make_kata(language)
    avatar = Avatar.new(kata, 'wolf') # 0
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
