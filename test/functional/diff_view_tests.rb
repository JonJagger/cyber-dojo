require 'test_helper'

# > cd cyberdojo/test
# > ruby functional/diff_view_tests.rb

def diff_view(avatar, tag)
    
    cmd  = "cd #{avatar.folder};"
    cmd += "git show #{tag}:manifest.rb;"
    manifest = eval IO::popen(cmd).read
    visible_files = manifest[:visible_files]
    
    cmd  = "cd #{avatar.folder};"
    cmd += "git diff #{tag-1} #{tag} sandbox;"   
    diff_lines = IO::popen(cmd).read

    view = {}
    builder = GitDiffBuilder.new()
    
    diffs = GitDiffParser.new(diff_lines).parse_all
    diffs.each do |sandbox_name,diff|
      name = %r|^sandbox/(.*)|.match(sandbox_name)[1] 
      source_lines = visible_files[name][:content]
      view[name] = builder.build(diff, source_lines.split("\n"))
      visible_files.delete(name)
    end
    
    visible_files.each do |name,file|
      view[name] = sameify(file[:content])
    end
    
    view
end

def sameify(source)
  result = []
  source.split("\n").each_with_index do |line,number|
    result << {
      :line => line,
      :type => :same,
      :number => number + 1
    }
  end
  result
end

#-----------------------------------------------
#-----------------------------------------------
#-----------------------------------------------

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

  def test_sameify
    expected =
    [
        { :line => "require 'untitled'", :type => :same, :number => 1 },
        { :line => "require 'test/unit'", :type => :same, :number => 2 },
        { :line => "", :type => :same, :number => 3 },
        { :line => "class TestUntitled < Test::Unit::TestCase", :type => :same, :number => 4 },
        { :line => "", :type => :same, :number => 5 },
        { :line => "  def test_simple", :type => :same, :number => 6 },
        { :line => "    assert_equal 9 * 6, answer", :type => :same, :number => 7 },
        { :line => "  end", :type => :same, :number => 8 },
        { :line => "", :type => :same, :number => 9 },
        { :line => "end", :type => :same, :number => 10 }
      ]
      assert_equal expected, sameify(test_untitled_rb)
    end
  
  #-----------------------------------------------
  
  def test_building_diff_view_from_git_repo
    root_test_folder_reset
    params = make_params
    assert Dojo::create(params)
    dojo = Dojo.new(params)
    filesets = { 'language' => 'Ruby' }
    avatar = Avatar.new(dojo, 'wolf', filesets)    
    # that will have created tag 0 in the repo

    manifest =
    {
      :visible_files =>
      {
        'cyberdojo.sh'     => { :content => cyberdojo_sh },
        'untitled.rb'      => { :content => untitled_rb },
        'test_untitled.rb' => { :content => test_untitled_rb }
      }
    }

    # create tag 1 in the repo 
    increments = avatar.run_tests(manifest)
    assert_equal :failed, increments.last[:outcome]

    # create tag 2 in the repo 
    manifest[:visible_files]['untitled.rb'][:content] = untitled_rb.sub('42', '54')
    increments = avatar.run_tests(manifest)
    assert_equal :passed, increments.last[:outcome]
    
    tag = 2    
    view = diff_view(avatar, tag)
    
    expected =
    {
      'untitled.rb' =>
      [
        { :line => "def answer", :type => :same, :number => 1 },
        { :line => "  42", :type => :deleted },
        { :line => "  54", :type => :added, :number => 2 },
        { :line => "end", :type => :same, :number => 3 },
      ],
      'test_untitled.rb' => sameify(test_untitled_rb),
      'cyberdojo.sh' => sameify(cyberdojo_sh)
    }
    
    assert_equal expected, view
    
  end

  #-----------------------------------------------

  def cyberdojo_sh
<<HERE
ruby test_untitled.rb
HERE
  end
  
  #-----------------------------------------------
  
  def test_untitled_rb 
<<HERE
require 'untitled'
require 'test/unit'

class TestUntitled < Test::Unit::TestCase

  def test_simple
    assert_equal 9 * 6, answer
  end

end
HERE
  end

  #-----------------------------------------------
  
  def untitled_rb
<<HERE
def answer
  42
end
HERE
  end  
  
end
