require 'test_helper'

class KataControllerTest < ActionController::TestCase

  class MockKata
    def initialize(language, unit_test_framework)
      @language, @unit_test_framework = language, unit_test_framework
    end
    def language
      @language
    end
    def unit_test_framework
      @unit_test_framework
    end
  end

  def test_parse_execution_terminated
    execution_terminated_output = "execution terminated after "
    expected = { :outcome => :timeout, :info => 'execution terminated after ' }
    actual = RunTestsOutputParser.new().parse(
		MockKata.new('c', 'assert'), execution_terminated_output)
    assert_equal expected, actual
  end

  #---------------------------------

  def test_parse_junit_test_fail_with_count
    junit_output = "Tests run: 5,  Failures: 4"
    actual = RunTestsOutputParser.new().parse(
		MockKata.new('java', 'junit'), junit_output)
    assert_equal :failed, actual[:outcome]
  end

  def test_parse_junit_test_zero_is_a_fail
    junit_output = "DemoTest.java:7: ';' expected" + "\n" + "OK (0 tests)"
    actual = RunTestsOutputParser.new().parse(
		MockKata.new('java', 'junit'), junit_output)
    assert_equal :failed, actual[:outcome]
  end

  def test_parse_junit_test_pass_with_count
    junit_output = "OK (42 test"
    actual = RunTestsOutputParser.new().parse(
		MockKata.new('java', 'junit'), junit_output)
    assert_equal :passed, actual[:outcome]
  end

  #---------------------------------

  def test_makefile_filter_filename_not_makefile
     name     = 'not_makefile'
     content  = "    abc"
     actual   = TestRunner.makefile_filter(name, content)
     expected = "    abc"
     assert_equal expected, actual
  end

  def test_makefile_filter_filename_is_makefile
     name     = 'makefile'
     content  = "    abc"
     actual   = TestRunner.makefile_filter(name, content)
     expected = "\tabc"
     assert_equal expected, actual
  end

  def test_makefile_filter_filename_is_Makefile_with_uppercase_M
     name     = 'Makefile'
     content  = "    abc"
     actual   = TestRunner.makefile_filter(name, content)
     expected = "\tabc"
     assert_equal expected, actual
  end

end
