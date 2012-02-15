require File.dirname(__FILE__) + '/../test_helper'

# > ruby test/functional/timeout_tests.rb

class RunTestsTimeOutTests < ActionController::TestCase

  Root_test_dir = RAILS_ROOT + '/test/katas'

  def root_test_dir_reset
    system("rm -rf #{Root_test_dir}")
    Dir.mkdir Root_test_dir
  end

  # Relies on gcc and make being installed

  def make_params
    { :kata_name => 'Jon Jagger', 
      :kata_root => Root_test_dir,
      :filesets_root => RAILS_ROOT + '/filesets',
      'language' => 'C',
      'exercise' => 'Unsplice',
      :browser => 'None (test)'
    }
  end
  
  def make_kata
    params = make_params
    fileset = InitialFileSet.new(params[:filesets_root], params['language'], params['exercise'])
    info = Kata::create_new(fileset, params)
    params[:kata_name] = info[:uuid]
    Kata.new(params)    
  end

  def ps_count
    `ps aux | grep -E "(cyberdojo|make|run\.tests)"`.lines.count
  end
  
  def test_that_code_with_infinite_loop_times_out_and_doesnt_leak_processes
    root_test_dir_reset
    kata = make_kata
    filename = 'untitled.c'
    avatar_name = Avatar::names.shuffle[0]
    avatar = Avatar.new(kata, avatar_name)
    visible_files = avatar.visible_files
    code = visible_files[filename]
    visible_files[filename] = code.sub('return 42;', 'for(;;);')
    
    ps_count_before = ps_count
    output = avatar.run_tests(visible_files)
    ps_count_after = ps_count
    assert_equal ps_count_before, ps_count_after, 'proper cleanup of shell processes'
    
    assert_not_nil output =~ /Terminated by the CyberDojo server after 10 seconds/
  end
  
end
