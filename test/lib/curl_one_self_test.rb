#!/bin/bash ../test_wrapper.sh

require 'minitest/autorun'
require_relative '../ideas/TestWithId'
require_relative 'lib_test_base'

class BackgroundProcessSpy
  def initialize
    @processes_started = []
  end

  attr_reader :processes_started

  def start(command)
    @processes_started << command
  end
end

class CurlOneSelfTests < LibTestBase #MiniTest::Test

  def self.tests
    @@tests ||= TestWithId.new(self)
  end

  def setup
    super
    set_disk_class_name     'DiskStub'
    set_git_class_name      'GitSpy'
    set_one_self_class_name 'OneSelfDummy'
    # important to use OneSelfDummy because
    # creating a new kata calls dojo.one_self.created
  end

  tests['2ED22E'].is 'kata created' do
    processes = BackgroundProcessSpy.new
    one_self = CurlOneSelf.new(processes)
#    kata = make_kata
#    exercise_name = kata.exercise.name
#    language_name,test_name = kata.language.display_name.split(',').map{|s| s.strip }
    hash = {
      :now => [2015, 9, 11, 18, 28, 14], #time_now,
      :kata_id => "F1A4B187E7", #kata.id
      :exercise_name => "Fizz_Buzz", #exercise_name,
      :language_name => "C (gcc)", #language_name,
      :test_name     => "assert", #test_name,
      :latitude   => '51.0190',
      :longtitude => '3.1000'
    }

    one_self.created(hash)

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
    '"dateTime":"2015-09-11T18:28:14-00:00",' +
    '"location":{"lat":"51.0190","long":"3.1000"},' +
    '"properties":{' +
    '"dojo-id":"F1A4B187E7",' +
    '"exercise-name":"Fizz_Buzz",' +
    '"language-name":"C (gcc)",' +
    '"test-name":"assert"}}' +
    # back to double quotes
    "' " +
    "https://api.1self.co/v1/streams/GSYZNQSYANLMWEEH/events"

    assert_equal 1, processes.processes_started.length, "Incorrect number of processes started"
    assert_equal expected_command, processes.processes_started[0], "Incorrect curl process started"
  end

end
