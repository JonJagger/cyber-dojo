#!/usr/bin/env ruby

require_relative 'controller_test_base'

class KataControllerTest  < ControllerTestBase

  test 'edit and then run-tests' do
    setup_dojo
    setup_language('fake-C#', 'nunit')
    setup_exercise('fake-Yatzy')
    id = checked_save_id('fake-C#','fake-Yatzy')

    get 'dojo/enter', :id => id
    avatar_name = json['avatar_name']

    setup_initial_edit(id,avatar_name)
    get 'kata/edit', :id => id, :avatar => avatar_name

    post 'kata/run_tests', # 1
      :format => :js,
      :id => id,
      :avatar => avatar_name,
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
      :id => id,
      :avatar => avatar_name,
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
