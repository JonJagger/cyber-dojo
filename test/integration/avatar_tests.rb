require File.dirname(__FILE__) + '/../test_helper'

class AvatarTests < ActionController::TestCase

  def setup
    super
    @kata = make_kata('Ruby-installed-and-working')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "deleted file is deleted from that repo tag" do
    avatar = Avatar.create(@kata, 'wolf')  # creates tag-0
    visible_files = avatar.visible_files
    deleted_filename = 'instructions'
    visible_files[deleted_filename] = 'Whatever'
    delta = {
      :changed => [ ],
      :unchanged => visible_files.keys,
      :deleted => [ ],
      :new => [ ]                                    
    }
    run_test(delta, avatar, visible_files)  # creates tag-1
    visible_files.delete(deleted_filename)
    delta = {
      :changed => [ ],
      :unchanged => visible_files.keys - [ deleted_filename ],
      :deleted => [ deleted_filename ],
      :new => [ ]                                          
    }    
    run_test(delta, avatar, visible_files)  # creates tag-2    
    before = avatar.visible_files(tag=1)
    assert before.keys.include?("#{deleted_filename}"),
          "before.keys.include?(#{deleted_filename})"          
    after = avatar.visible_files(tag=2)
    assert !after.keys.include?("#{deleted_filename}"),
          "!after.keys.include?(#{deleted_filename})"
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test "diff_lines is not empty when change in files" do
    avatar = Avatar.create(@kata, 'wolf') # 0
    visible_files = avatar.visible_files
    delta = {
      :changed => [ ],
      :unchanged => visible_files.keys,
      :deleted => [ ],
      :new => [ ]                              
     }    
    run_test(delta, avatar, visible_files) # 1
    visible_files['cyber-dojo.sh'] += 'xxxx'
    delta = {
      :changed => [ 'cyber-dojo.sh' ],
      :unchanged => visible_files.keys - [ 'cyber-dojo.sh' ],
      :deleted => [ ],
      :new => [ ]                              
     }
    run_test(delta, avatar, visible_files) # 2    
    traffic_lights = avatar.traffic_lights
    assert_equal 2, traffic_lights.length
    was_tag = nil
    now_tag = nil
    actual = avatar.diff_lines(was_tag = 1, now_tag = 2)    
    assert actual.match(/^diff --git/)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test "diff_lines shows added file" do
    avatar = Avatar.create(@kata, 'wolf') # 0
    visible_files = avatar.visible_files
    added_filename = 'unforgiven.txt'
    content = 'starring Clint Eastwood'
    visible_files[added_filename] = content
    delta = {
      :changed => [ ],
      :unchanged => visible_files.keys - [ added_filename ],
      :deleted => [ ],
      :new => [ added_filename ]                        
    }
    run_test(delta, avatar, visible_files) # 1
    actual = avatar.diff_lines(was_tag=0, now_tag=1)
    expected =
      [
        "diff --git a/sandbox/#{added_filename} b/sandbox/#{added_filename}",
        "new file mode 100644",
        "index 0000000..1bdc268",
        "--- /dev/null",
        "+++ b/sandbox/#{added_filename}",
        "@@ -0,0 +1 @@",
        "+#{content}"
      ].join("\n")
    assert actual.include?(expected)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "diff_lines shows deleted file" do
    avatar = Avatar.create(@kata, 'wolf') # 0
    visible_files = avatar.visible_files
    deleted_filename = 'instructions'
    content = 'tweedle_dee'
    visible_files[deleted_filename] = content
    
    delta = {
      :changed => [ deleted_filename ],
      :unchanged => visible_files.keys - [ deleted_filename ],
      :deleted => [ ],
      :new => [ ]                  
    }    
    run_test(delta, avatar, visible_files)  # 1
    #- - - - -
    visible_files.delete(deleted_filename)    
    delta = {
      :changed => [ ],
      :unchanged => visible_files.keys - [ deleted_filename ],
      :deleted => [ deleted_filename ],
      :new => [ ]                        
    }
    run_test(delta, avatar, visible_files)  # 2    
    #- - - - -
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
    assert actual.include?(expected), actual
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "output is correct on refresh" do
    language = 'Ruby-installed-and-working'
    kata = make_kata(language)
    avatar = Avatar.create(kata, 'lion')
    visible_files = avatar.visible_files
    delta = {
      :changed => visible_files.keys,
      :unchanged => [ ],
      :deleted => [ ],
      :new => [ ]      
    }        
    output = run_test(delta, avatar, visible_files)
    visible_files['output'] = output    
    traffic_light = { :colour => 'amber' }
    avatar.save_run_tests(visible_files, traffic_light)    
    # now refresh
    avatar = kata['lion']
    assert_equal output, avatar.visible_files['output']
  end    

end
