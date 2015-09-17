
module OutputColour # mix-in

  module_function

  #  'red'   - the tests ran but at least one failed
  #  'amber' - the tests could not be run (eg syntax error)
  #  'green' - the tests ran and all passed
  #  'timed_out' - the tests did not complete in time

  def self.of(unit_test_framework, output)
    if Regexp.new('Unable to complete the test').match(output)
      'timed_out'
    else
      self.send("parse_#{unit_test_framework}", output).to_s
    end
  end

  def self.parse_d_unittest(output)
    return :red   if /core\.exception\.AssertError/.match(output)
    return :green if /All tests passed/.match(output)
    return :amber
  end

  def self.parse_funit(output)
    return :red   if /==========\[ SUMMARY \]==========[^:]*:\s*failed/.match(output)
    return :green if /==========\[ SUMMARY \]==========[^:]*:\s*passed/.match(output)
    return :amber
  end

  def self.parse_node(output)
    return :red   if /AssertionError/.match(output)
    return :green if /^All tests passed/.match(output)
    return :amber
  end

  def self.parse_mocha(output)
    return :red   if /AssertionError/.match(output)
    return :green if /(\d+) passing \((\d+)ms\)/.match(output)
    return :amber
  end

  def self.parse_cpputest(output)
    return :red   if /Errors \((\d+) failures, (\d+) tests/.match(output)
    return :green if /OK \((\d+) tests, (\d+) ran/.match(output)
    return :amber
  end

  def self.parse_eunit(output)
    return :red   if /Failed: /.match(output)
    return :green if /passed./.match(output)
    return :amber
  end

  def self.parse_python_unittest(output)
    return :red   if /FAILED \(failures=/.match(output)
    return :green if /OK/.match(output)
    return :amber
  end

  def self.parse_python_pytest(output)
    return :red   if /=== FAILURES ===/.match(output)
    return :green if /=== (\d*) passed/.match(output)
    return :amber
  end

  def self.parse_catch(output)
    return :red   if /failed \(\d* assertion/.match(output)
    return :green if /All tests passed/.match(output)
    return :amber
  end

  def self.parse_cunity(output)
    return :red if /^FAIL/.match(output)
    return :green if /^OK/.match(output)
    return :amber
  end

  def self.parse_junit(output)
    return :red   if /^Tests run: (\d*),(\s)+Failures: (\d*)/.match(output)
    return :green if /^OK \((\d*) test/.match(output)
    return :amber
  end

  def self.parse_java_cucumber(output)
    return :red   if /FAILURES!!!/.match(output)
    return :green if /OK \((\d*) tests\)/.match(output)
    return :amber
  end

  def self.parse_cassert(output)
    return :red   if /(.*)Assertion(.*)failed./.match(output)
    return :green if /(All|\d*) tests passed/.match(output)
    return :amber
  end

  def self.parse_google_test(output)
    return :red   if /\[  FAILED  \]/.match(output)
    return :green if /\[  PASSED  \]/.match(output)
    return :amber
  end

  def self.parse_boost_test(output)
    return :red   if /\*\*\* (\d+) failures? detected/.match(output)
    return :green if /\*\*\* No errors detected/.match(output)
    return :amber
  end

  def self.parse_ruby_rspec(output)
    return :green if /(\d*) example(s?), 0 failures/.match(output)
    return :red   if /(\d*) example(s?), (\d*) failure(s?)/.match(output)
    return :red   if /(\d*) scenario(s?) \((\d*) failed/.match(output)
    return :green if /(\d*) scenario(s?) \((\d*) passed/.match(output)
    return :amber
  end

  def self.parse_nunit(output)
    return :red   if /^Errors and Failures\:/.match(output)
    return :green if /^Tests run: (\d*), Errors: 0, Failures: 0/.match(output)
    return :amber
  end

  def self.parse_runit(output)
    return :red   if /Error in check(.*)/.match(output)
    return :green if /\"All tests passed\"/.match(output)
    return :amber
  end

  def self.parse_bcpl_all_tests_passed(output)
    return :amber if /bcpl failed returncode/.match(output)
    return :green if /All tests passed/.match(output)
    return :red
  end

  def self.parse_bash_shunit2(output)
    return :amber if /shunit2:ERROR/.match(output)
    return :red   if /Ran (\d*) test(s?)\.\n\nFAILED/.match(output)
    return :green if /Ran (\d*) test(s?)\.\n\nOK/.match(output)
    return :amber
  end

  def self.parse_rust_test(output)
    return :red   if /test result: FAILED/.match(output)
    return :green if /test result: ok/.match(output)
    return :amber
  end

  def self.parse_go_testing(output)
    return :amber if /FAIL(\s*)_\/sandbox \[build failed\]/.match(output)
    return :red   if /FAIL/.match(output)
    return :green if /PASS/.match(output)
    return :amber
  end

  def self.parse_php_unit(output)
    return :amber if /PHP Parse error:/.match(output)
    return :red   if /FAILURES!/.match(output)
    return :green if /OK \(/.match(output)
    return :amber
  end

  def self.parse_perl_test_simple(output)
    return :green if /All tests successful/.match(output)
    return :amber if /syntax error/.match(output)
    return :amber if /aborted due to compilation errors/.match(output)
    return :red
  end

  def self.parse_ruby_mini_test(output)
    ruby_pattern = Regexp.new('^(\d*) tests, (\d*) assertions, (\d*) failures, (\d*) errors')
    if match = ruby_pattern.match(output)
      return :amber if match[4] != '0'
      return :red   if match[3] != '0'
      return :green
    else
      return :amber
    end
  end

  def self.parse_ruby_test_unit(output)
    self.parse_ruby_mini_test(output)
  end

  def self.parse_hunit(output)
    hunit_pattern = /Counts \{cases = (\d+), tried = (\d+), errors = (\d+), failures = (\d+)\}/
    if match = hunit_pattern.match(output)
      return :amber if match[3] != '0'
      return :red   if match[4] != '0'
      return :green
    else
      return :amber
    end
  end

  def self.parse_ruby_approval(output)
    return :amber if /(SyntaxError)/.match(output)
    return :amber if /NameError/.match(output)
    return :amber if /LoadError/.match(output)
    return :amber if /NoMethodError/.match(output)
    return :red   if /Approvals::ApprovalError/.match(output)
    return :green
  end

  def self.parse_groovy_spock(output)
    green_pattern = Regexp.new('^OK \((\d*) test')
    if match = green_pattern.match(output)
      return :green if match[1] != '0'
      return :red # treat zero passes as a fail
    end
    amber_patterns = [
      'groovyc: command not found',
      'groovy\.lang',
      'MultipleCompilationErrorsException'
    ]
    return :amber if amber_patterns.any? { |pattern| Regexp.new(pattern).match(output) }
    return :red
  end

  def self.parse_clojure_test(output)
    syntax_error_pattern = /Exception in thread/
    ran_pattern = /Ran (\d+) tests containing (\d+) assertions.(\s*)(\d+) failures, (\d+) errors./
    return :amber if syntax_error_pattern.match(output)
    return :red   if output.scan(ran_pattern).any? { |res| res[3] != '0' || res[4] != '0' }
    return :green if output.scan(ran_pattern).any? { |res| res[3] == '0' && res[4] == '0' }
    return :amber
  end

  def self.parse_jasmine(output)
    jasmine_pattern = /(\d+) specs?, (\d+) failures?/
    if match = jasmine_pattern.match(output)
      match[2] === '0' ? :green : :red
    else
      :amber
    end
  end

  def self.parse_scala_test(output)
    scala_pattern = /Tests: succeeded (\d+), failed (\d+), canceled (\d+), ignored (\d+), pending (\d+)/
    if match = scala_pattern.match(output)
      match[2] === '0' ? :green : :red
    else
      :amber
    end
  end

  def self.parse_cppigloo(output)
    igloo_pattern =  /Test run complete. (\d+) tests run, (\d+) succeeded, (\d+) failed./
    if match = igloo_pattern.match(output)
      match[3] === '0' ? :green : :red
    else
      :amber
    end
  end

end
