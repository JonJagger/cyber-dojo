require 'test_helper'

class KataControllerTest < ActionController::TestCase

  class MockExercise
    def language; 'c'; end
    def unit_test_framework; 'tequila'; end
  end

  def test_parse_run_tests_stopped_output
    output = "run-tests stopped "
    expected = { :outcome => :error, :info => 'run-tests stopped' }
    actual = parse_run_test_output(MockExercise.new, output)
    assert_equal expected, actual
  end

  #---------------------------------

  def test_parse_tequila_test_fail_with_count
    tequila_output = "TEQUILA FAILED: 2 passed, 3 failed"
    expected = { :outcome => :failed, :info => '3' }
    actual = parse_c_tequila(tequila_output)
    assert_equal expected, actual
  end

  def test_parse_tequila_test_doesnt_compile_is_an_error
    tequila_output = "unsplice.c:3: error: expected declaration specifiers before ‘ss"
    expected = { :outcome => :error, :info => "syntax error" }
    actual = parse_c_tequila(tequila_output)
    assert_equal expected, actual
  end

  def test_parse_tequila_test_pass_with_count
    tequila_output = "TEQUILA PASSED: 7 passed, 0 failed"
    expected = { :outcome => :passed, :info => '7' }
    actual = parse_c_tequila(tequila_output)
    assert_equal expected, actual
  end

  #---------------------------------

  def test_parse_junit_test_fail_with_count
    junit_output = "Tests run: 5,  Failures: 4"
    expected = { :outcome => :failed, :info => '4' }
    actual = parse_java_junit(junit_output)
    assert_equal expected, actual
  end

  def test_parse_junit_test_zero_is_a_fail
    junit_output = "DemoTest.java:7: ';' expected" + "\n" + "OK (0 tests)"
    expected = { :outcome => :failed, :info => '0' }
    actual = parse_java_junit(junit_output)
    assert_equal expected, actual
  end

  def test_parse_junit_test_pass_with_count
    junit_output = "OK (42 test"
    expected = { :outcome => :passed, :info => '42' }
    actual = parse_java_junit(junit_output)
    assert_equal expected, actual
  end

  #---------------------------------

  def test_makefile_filter_filename_not_makefile
     name     = 'not_makefile'
     content  = "    abc"
     actual   = makefile_filter(name, content)
     expected = "    abc"
     assert_equal expected, actual
  end

  def test_makefile_filter_filename_is_makefile
     name     = 'makefile'
     content  = "    abc"
     actual   = makefile_filter(name, content)
     expected = "\tabc"
     assert_equal expected, actual
  end

  def test_makefile_filter_filename_is_Makefile_with_uppercase_M
     name     = 'Makefile'
     content  = "    abc"
     actual   = makefile_filter(name, content)
     expected = "\tabc"
     assert_equal expected, actual
  end

  #---------------------------------

  def test_diff_time_to_s_when_difference_is_0_02
    now   = Time.local(2009,9,7,15,8,55,0)
    later = Time.local(2009,9,7,15,8,57,0)
    assert_equal "0:02", diff_time_to_s(now, later)  # leading zero
  end

  def test_diff_time_to_s_when_difference_is_0_22
    now   = Time.local(2009,9,7,15,8,55,0)
    later = Time.local(2009,9,7,15,9,17,0)
    assert_equal "0:22", diff_time_to_s(now, later) # leading zero
  end

  def test_diff_time_to_s_when_difference_is_1_00
    now   = Time.local(2009,9,7,15,8,4,0)
    later = Time.local(2009,9,7,15,9,4,0)
    assert_equal "1:00", diff_time_to_s(now, later) # no leading zero
  end

  def test_diff_time_to_s_when_difference_is_11_09
    now   = Time.local(2009,9,7,15,8,4,0)
    later = Time.local(2009,9,7,15,19,13,0)
    assert_equal "11:09", diff_time_to_s(now, later) 
  end

  def test_diff_time_to_s_when_difference_is_1_02_04
    now   = Time.local(2009,9,7,15,8,4,0)
    later = Time.local(2009,9,7,16,10,8,0)
    assert_equal "1:02:04", diff_time_to_s(now, later) # two leading zeros
  end

  #---------------------------------

  def test_dhms
    assert_equal [0, 0, 0,32], dhms(0*3600 +  0*60 + 32)
    assert_equal [0, 0, 1,47], dhms(0*3600 +  1*60 + 47)
    assert_equal [0, 8,26, 3], dhms(8*3600 + 26*60 +  3)
    assert_equal [2, 3,15,38], dhms(2*24*3600 + 3*3600 + 15*60 + 38)
  end

  #---------------------------------

  def test_dhms_display
    assert_equal       "2:01", dhms_display(0, 0, 2, 1)
    assert_equal       "2:11", dhms_display(0, 0, 2,11)
    assert_equal      "59:07", dhms_display(0, 0,59, 7)
    assert_equal      "59:17", dhms_display(0, 0,59,17)
    assert_equal    "1:09:51", dhms_display(0, 1, 9,51)
    assert_equal "4:02:23:42", dhms_display(4, 2,23,42)
  end

  #---------------------------------

  def time_to_array(time)
    [time.year, time.month, time.day, time.hour, time.min, time.sec]
  end

  #---------------------------------

  def test_lead_zero_value_less_than_10_has_leading_zero
    assert_equal "05", lead_zero(5)
  end

  def test_lead_zero_value_greater_than_10_does_not_have_leading_zero
    assert_equal "42", lead_zero(42)
  end


end
