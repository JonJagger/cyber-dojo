#!/usr/bin/env ruby

require_relative './app_lib_test_base'

class OutputRubyApprovalTests < AppLibTestBase

  test "NameError is amber" do
    output = [
      "F",
      "",
      "Failures:",
      "",
      "  1) untitled sums has answer",
      "     Failure/Error: it \"has answer\" do asdasdasd",
      "     NameError:",
      "       undefined local variable or method `asdasdasd' for #<RSpec::Core::ExampleGroup::Nested_1::Nested_1:0x00000001acb150>",
      "     # ./untitled_spec.rb:11:in `block (3 levels) in <top (required)>'",
      "",
      "Finished in 0.0009 seconds",
      "1 example, 1 failure",
      "",
      "Failed examples:",
      "",
      "rspec ./untitled_spec.rb:11 # untitled sums has answer"
    ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test "one test passes is green" do
    output = [
      ".",
      "",
      "Finished in 0.00139 seconds",
      "1 example, 0 failures"
    ].join("\n")
    assert_equal :green, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test "one test fails is red" do
    output = [
      "F",
      "",
      "Failures:",
      "",
      "  1) untitled sums has answer",
      "     Failure/Error: verify do",
      "     Approvals::ApprovalError:",
      "       Approval Error: Received file \"./untitled_sums_has_answer.received.txt\" does not match approved \"./untitled_sums_has_answer.approved.txt\".",
      "     # ./untitled_spec.rb:12:in `block (3 levels) in <top (required)>'",
      "",
      "Finished in 0.01855 seconds",
      "1 example, 1 failure",
      "",
      "Failed examples:",
      "",
      "rspec ./untitled_spec.rb:11 # untitled sums has answer"
    ].join("\n")
    assert_equal :red, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test "two tests fails is red" do
    output = [
      "FF",
      "",
      "Failures:",
      "",
      "  1) untitled sums has answer",
      "     Failure/Error: verify do",
      "     Approvals::ApprovalError:",
      "       Approval Error: Received file \"./untitled_sums_has_answer.received.txt\" does not match approved \"./untitled_sums_has_answer.approved.txt\".",
      "     # ./untitled_spec.rb:12:in `block (3 levels) in <top (required)>'",
      "",
      "  2) untitled2 sums has answer",
      "     Failure/Error: verify do",
      "     Approvals::ApprovalError:",
      "       Approval Error: Approval file \"./untitled2_sums_has_answer.approved.txt\" not found.",
      "     # ./untitled_spec.rb:26:in `block (3 levels) in <top (required)>'",
      "",
      "Finished in 0.03809 seconds",
      "2 examples, 2 failures",
      "",
      "Failed examples:",
      "",
      "rspec ./untitled_spec.rb:11 # untitled sums has answer",
      "rspec ./untitled_spec.rb:25 # untitled2 sums has answer"
    ].join("\n")
    assert_equal :red, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test "one pass and one fail is red" do
    output = [
      "F.",
      "",
      "Failures:",
      "",
      "  1) untitled sums has answer",
      "     Failure/Error: verify do",
      "     Approvals::ApprovalError:",
      "       Approval Error: Received file \"./untitled_sums_has_answer.received.txt\" does not match approved \"./untitled_sums_has_answer.approved.txt\".",
      "     # ./untitled_spec.rb:12:in `block (3 levels) in <top (required)>'",
      "",
      "Finished in 0.0336 seconds",
      "2 examples, 1 failure",
      "",
      "Failed examples:",
      "",
      "rspec ./untitled_spec.rb:11 # untitled sums has answer"
    ].join("\n")
    assert_equal :red, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test "syntax error is amber" do
    output = [
      "/usr/lib/ruby/1.9.1/rubygems/custom_require.rb:36:in `require': /sandbox/untitled.rb:3: syntax error, unexpected tIDENTIFIER, expecting keyword_end (SyntaxError)",
      "	from /usr/lib/ruby/1.9.1/rubygems/custom_require.rb:36:in `require'",
      "	from /sandbox/untitled_spec.rb:3:in `<top (required)>'",
      "	from /var/lib/gems/1.9.1/gems/rspec-core-2.14.8/lib/rspec/core/configuration.rb:896:in `load'"
    ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test "LoadError is amber" do
    output = [
      "/usr/lib/ruby/1.9.1/rubygems/custom_require.rb:36:in `require': cannot load such file -- ./untitleds (LoadError)",
      "	from /usr/lib/ruby/1.9.1/rubygems/custom_require.rb:36:in `require'",
      "	from /sandbox/untitled_spec.rb:3:in `<top (required)>'",
      "	from /var/lib/gems/1.9.1/gems/rspec-core-2.14.8/lib/rspec/core/configuration.rb:896:in `load'",
      "	from /var/lib/gems/1.9.1/gems/rspec-core-"
    ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test "NoMethodError is amber" do
    output = [
      "/sandbox/untitled_spec.rb:3:in `<top (required)>': undefined method `srequire' for main:Object (NoMethodError)",
      "	from /var/lib/gems/1.9.1/gems/rspec-core-"
    ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  def colour_of(output)
    OutputParser::parse_ruby_approval(output)
  end

end
