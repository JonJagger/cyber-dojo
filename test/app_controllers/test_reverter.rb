#!/usr/bin/env ruby

require_relative 'controller_test_base'

class ReverterControllerTest  < ControllerTestBase

  test 'revert' do
    @id = create_kata
    enter
    kata_edit    
    kata_run_tests file_content: { 'cyber-dojo.sh' => "echo abc" },
                   file_hashes_incoming: { 'cyber-dojo.sh' => 234234 },
                   file_hashes_outgoing: { 'cyber-dojo.sh' => -4545645678 } #1
    kata_run_tests file_content: { 'cyber-dojo.sh' => "echo def" },
                   file_hashes_incoming: { 'cyber-dojo.sh' => 234234 },
                   file_hashes_outgoing: { 'cyber-dojo.sh' => -4545645678 } #2
    get 'reverter/revert', :format => :json,
                           id:@id,
                           avatar:@avatar_name,
                           tag:1
    visible_files = json['visibleFiles']
    assert_not_nil visible_files
    assert_not_nil visible_files['output']
    assert_not_nil visible_files['cyber-dojo.sh']
    assert_equal 'echo abc', visible_files['cyber-dojo.sh']
  end

end
