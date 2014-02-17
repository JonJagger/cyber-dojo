require File.dirname(__FILE__) + '/../test_helper'
#require File.dirname(__FILE__) + '/stub_disk_file'

# Lot of duplication of root_dir in ctor arguments etc
# Sign of a missing abstraction...
#
#   cd = Cyber_Dojo.new(root_dir)
#   kata = cd['AE346E0D21']
#   avatar = kata['hippo']   
#
#  Cyber_Dojo.new(root_dir)['AE346E0D21'].exists?
#  Cyber_Dojo.new(root_dir)['AE346E0D21']['hippo'].exists?


class Cyber_DojoTests < ActionController::TestCase
  
  def setup
    @dir = '/blah'
    @cd = Cyber_Dojo.new(@dir)
  end
  
  test "dir is as set in ctor" do
    assert_equal @dir, @cd.dir
  end

  test "cd[id] gives you kata which knows its dir" do
    assert_equal @dir+'/katas/12/34567890', @cd['1234567890'].dir
  end

end
