#!/usr/bin/env ruby

require_relative 'controller_test_base'

class ReverterControllerTest  < ControllerTestBase

  test 'revert' do
    @id = create_kata
    enter
    kata_edit    
    filename = 'cyber-dojo.sh'
    old_content = 'echo abc'
    kata_run_tests file_content:         { filename => old_content },
                   file_hashes_incoming: { filename => 234234 },
                   file_hashes_outgoing: { filename => -4545645678 } #1
    new_content = 'something different'
    kata_run_tests file_content:         { filename => new_content },
                   file_hashes_incoming: { filename => 234234 },
                   file_hashes_outgoing: { filename => -4545645678 } #2
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
