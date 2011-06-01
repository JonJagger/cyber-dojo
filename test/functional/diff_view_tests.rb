require 'test_helper'

# > cd cyberdojo/test
# > ruby functional/diff_view_tests.rb

class DiffViewTests < ActionController::TestCase

  ROOT_TEST_FOLDER = 'test_dojos'
  DOJO_NAME = 'Jon Jagger'
  # the test_dojos sub-folder for 'Jon Jagger' is
  # 38/1fa3eaa1a1352eb4bd6b537abbfc4fd57f07ab

  def root_test_folder_reset
    system("rm -rf #{ROOT_TEST_FOLDER}")
    Dir.mkdir ROOT_TEST_FOLDER
  end

  def make_params
    { :dojo_name => DOJO_NAME, 
      :dojo_root => Dir.getwd + '/' + ROOT_TEST_FOLDER,
      :filesets_root => Dir.getwd + '/../filesets'
    }
  end

  #-----------------------------------------------
  
  def test_building_diff_view_from_git_repo
    root_test_folder_reset
    params = make_params
    assert Dojo::create(params)
    dojo = Dojo.new(params)
    language = 'Ruby'
    avatar = dojo.create_avatar({ 'language' => language })    
    # that will have created tag 0 in the repo

test_untitled_rb = <<HERE
require 'untitled'
require 'test/unit'

class TestUntitled < Test::Unit::TestCase

  def test_simple
    assert_equal 9 * 6, answer  
  end

end
HERE

untitled_rb = <<HERE
def answer
  42
end
HERE

    manifest =
    {
      :visible_files =>
      {
        'cyberdojo.sh' =>
        {
          :content => 'ruby test_untitled.rb'
        },
        'untitled.rb'=>
        {
          :content => untitled_rb
        },
        'test_untitled.rb' =>
        {
          :content => test_untitled_rb
        }
      }
    }

    # create tag 1 in the repo 
    increments = avatar.run_tests(manifest)
    assert_equal :failed, increments.last[:outcome]

    # create tag 2 in the repo 
    manifest[:visible_files]['untitled.rb'][:content] = untitled_rb.sub('42', '54')
    increments = avatar.run_tests(manifest)
    assert_equal :passed, increments.last[:outcome]

    # Now grab the diffs
    tag = 2    
    cmd = "cd #{avatar.folder};"
    cmd += "git diff #{tag-1} #{tag} sandbox;"   
    diff = IO::popen(cmd).read

    expected_diff =
    {
        :prefix_lines =>  
          [
            "diff --git a/sandbox/untitled.rb b/sandbox/untitled.rb",
            "index 5c4b3ab..d7efe57 100644"
          ],
        :was_filename => 'sandbox/untitled.rb',
        :now_filename => 'sandbox/untitled.rb',
        :chunks =>
          [
            {
              :range =>
              {
                :was => { :start_line => 1, :size => 3 },
                :now => { :start_line => 1, :size => 3 },
              },
              :before_lines => [ "def answer"],
              :sections =>
              [
                {
                  :deleted_lines => [ "  42" ],
                  :added_lines   => [ "  54" ],
                  :after_lines => [ "end" ]
                }, # section
              ] # sections
            } # chunk
          ] # chunks
    } # expected

    actual_diff = GitDiffParser.new(diff).parse
    assert_equal expected_diff, actual_diff

    # Now grab the current version of the files
    
    # And finally make the diff-view

    
  end

end
