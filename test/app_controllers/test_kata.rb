#!/usr/bin/env ruby

require_relative 'controller_test_base'

class KataControllerTest  < ControllerTestBase

  test 'edit and then run-tests' do
    stub_setup
    enter
    kata_edit

    post 'kata/run_tests', # 1
      :format => :js,
      :id => @id,
      :avatar => @avatar_name,
      :file_content => {
        'cyber-dojo.sh' => ""
      },
      :file_hashes_incoming => {
        'cyber-dojo.sh' => 234234
      },
      :file_hashes_outgoing => {
        'cyber-dojo.sh' => -4545645678
      }

    post 'kata/run_tests', # 2
      :format => :js,
      :id => @id,
      :avatar => @avatar_name,
      :file_content => {
        'cyber-dojo.sh' => ""
      },
      :file_hashes_incoming => {
        'cyber-dojo.sh' => 234234
      },
      :file_hashes_outgoing => {
        'cyber-dojo.sh' => -4545645678
      }
  end

end
