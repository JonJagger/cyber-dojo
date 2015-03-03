#!/usr/bin/env ruby

require_relative 'controller_test_base'

class ReverterControllerTest  < ControllerTestBase

  test 'revert' do
    @id = create_kata
    enter
    kata_edit    
    filename = 'cyber-dojo.sh'
    old_content = 'echo abc'
    new_content = 'something different'    
    kata_run_tests make_file_hash(filename,old_content,234234, -4545645678) #1
    kata_run_tests make_file_hash(filename,new_content,234234, -5674378)    #2
    get 'reverter/revert', :format => :json,
                           id:@id,
                           avatar:@avatar_name,
                           tag:1
    visible_files = json['visibleFiles']
    assert_not_nil visible_files
    assert_not_nil visible_files['output']
    assert_not_nil visible_files[filename]
    assert_equal old_content, visible_files[filename]
  end

end
