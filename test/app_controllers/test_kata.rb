#!/usr/bin/env ruby

require_relative 'controller_test_base'

class KataControllerTest  < ControllerTestBase

  test 'edit and then run-tests' do
    stub_setup
    enter
    kata_edit
    filename = 'cyber-dojo.sh'
    kata_run_tests file_content:         { filename => '' },
                   file_hashes_incoming: { filename => 234234 },
                   file_hashes_outgoing: { filename => -4545645678 } #1
    kata_run_tests file_content:         { filename => '' },
                   file_hashes_incoming: { filename => 234234 },
                   file_hashes_outgoing: { filename => -4545645678 } #2
  end
  
end
