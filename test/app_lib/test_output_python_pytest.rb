#!/usr/bin/env ruby

require_relative './app_lib_test_base'

class OutputPythonPyTestTests < AppLibTestBase

  test "failing test is red" do
    output =
      [
        "============================= test session starts ==============================",
        "platform linux2 -- Python 2.7.5 -- py-1.4.20 -- pytest-2.5.2",
        "collected 1 items",
        "",
        "test_untitled.py F",
        "",
        "=================================== FAILURES ===================================",
        "_________________________________ test_answer __________________________________",
        "",
        "    def test_answer():",
        "        '''simple example to start you off'''",
        "        obj = untitled.Untitled()",
        ">       assert obj.answer() == 6*9",
        "E       assert 42 == (6 * 9)",
        "E        +  where 42 = <bound method Untitled.answer of <untitled.Untitled instance at 0x1665998>>()",
        "E        +    where <bound method Untitled.answer of <untitled.Untitled instance at 0x1665998>> = <untitled.Untitled instance at 0x1665998>.answer",
        "",
        "test_untitled.py:6: AssertionError",
        "=========================== 1 failed in 0.02 seconds ==========================="
      ].join("\n")
    assert_equal :red, colour_of(output)
  end

  #- - - - - - - - - - - - - - - -

  test "one test passed and none failing is green" do
    output =
      [
        "============================= test session starts ==============================",
        "platform linux2 -- Python 2.7.5 -- py-1.4.20 -- pytest-2.5.2",
        "collected 1 items",
        "",
        "test_untitled.py .",
        "",
        "=========================== 1 passed in 0.01 seconds ==========================="
      ].join("\n")
    assert_equal :green, colour_of(output)
  end

  #- - - - - - - - - - - - - - - -
  
  test "two tests passed and none failing is green" do
    output =
      [
        "============================= test session starts ==============================",
        "platform linux2 -- Python 2.7.5 -- py-1.4.20 -- pytest-2.5.2",
        "collected 2 items",
        "",
        "test_untitled.py ..",
        "",
        "=========================== 2 passed in 0.02 seconds ==========================="
      ].join("\n")
    assert_equal :green, colour_of(output)
  end

  #- - - - - - - - - - - - - - - -

  test "one passing test and one failing test is red" do
    output =
      [
        "============================= test session starts ==============================",
        "platform linux2 -- Python 2.7.5 -- py-1.4.20 -- pytest-2.5.2",
        "collected 2 items",
        "",
        "test_untitled.py .F",
        "",
        "=================================== FAILURES ===================================",
        "_________________________________ test_answer2 _________________________________",
        "",
        "    def test_answer2():",
        "        '''simple example to start you off'''",
        "        obj = untitled.Untitled()",
        ">       assert obj.answer() == 6*9",
        "E       assert 42 == (6 * 9)",
        "E        +  where 42 = <bound method Untitled.answer of <untitled.Untitled instance at 0x12a7d40>>()",
        "E        +    where <bound method Untitled.answer of <untitled.Untitled instance at 0x12a7d40>> = <untitled.Untitled instance at 0x12a7d40>.answer",
        "",
        "test_untitled.py:11: AssertionError",
        "====================== 1 failed, 1 passed in 0.03 seconds ======================"
      ].join("\n")
    assert_equal :red, colour_of(output)
  end

  #- - - - - - - - - - - - - - - -

  test "syntax error is amber" do
    output =
    [
      "============================= test session starts ==============================",
      "platform linux2 -- Python 2.7.5 -- py-1.4.20 -- pytest-2.5.2",
      "collected 0 items / 1 errors",
      "",
      "==================================== ERRORS ====================================",
      "______________________ ERROR collecting test_untitled.py _______________________",
      "/usr/local/lib/python2.7/dist-packages/_pytest/python.py:451: in _importtestmodule",
      ">           mod = self.fspath.pyimport(ensuresyspath=True)",
      "/usr/local/lib/python2.7/dist-packages/py/_path/local.py:620: in pyimport",
      ">           __import__(modname)",
      "E             File \"/sandbox/test_untitled.py\", line 6",
      "E               assert obj.answer() == 6*7 ssd",
      "E                                            ^",
      "E           SyntaxError: invalid syntax",
      "=========================== 1 error in 0.06 seconds ============================"
    ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - -

  test "error in cyber-dojo.sh is amber" do
    output =
    [
      "./cyber-dojo.sh: 1: ./cyber-dojo.sh: sdpython: not found"
    ].join("\n")
    assert_equal :amber, colour_of(output)
  end
  
  #- - - - - - - - - - - - - - - -

  def colour_of(output)
    OutputParser::parse_python_pytest(output)
  end

end
