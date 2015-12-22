#!/bin/bash ../test_wrapper.sh

require_relative './lib_test_base'

class OneSelfCurlTests < LibTestBase

  def setup
    super
    set_shell_class('HostShellMock')
    set_one_self_class('OneSelfCurl')
  end

  def teardown
    super
    shell.teardown
  end

  test '6B2BB0',
  'kata created' do

    expected_command =
      "curl " +
      "--silent " +
      "--header content-type:application/json " +
      "--header authorization:ddbc8384eaf4b6f0e70d66b606ccbf7ad4bb22bfe113 " +
      "-X POST " +
      "-d '" +
      # switch to single quotes to save having to escape double quotes
      '{' +
      '"objectTags":["cyber-dojo"],' +
      '"actionTags":["create"],' +
      # Got a fail: dateTime came out as 2015-09-11T17
      # Not investigating further as Curl might not be kept anyway
      '"dateTime":"2015-09-11T17:28:14-00:00",' +
      '"location":{"lat":"51.0190","long":"3.1000"},' +
      '"properties":{' +
      '"dojo-id":"F1A4B187E7",' +
      '"exercise-name":"Fizz_Buzz",' +
      '"language-name":"C (gcc)",' +
      '"test-name":"assert"}}' +
      # back to double quotes
      "' " +
      "https://api.1self.co/v1/streams/GSYZNQSYANLMWEEH/events"

    shell.mock_daemon_exec(expected_command)

    one_self.created({
        :now           => [2015, 9, 11, 18, 28, 14],
        :kata_id       => "F1A4B187E7",
        :exercise_name => "Fizz_Buzz",
        :language_name => "C (gcc)",
        :test_name     => "assert",
        :latitude      => '51.0190',
        :longtitude    => '3.1000'
      })

  end

end
