
module OutputParser

  #  'red'   - this means the tests ran but at least one failed
  #  'amber' - this means the tests could not be run (eg syntax error)
  #  'green' - this means the tests ran and all passed

  def self.colour(unit_test_framework, output)
    if Regexp.new('Terminated by the cyber-dojo server after').match(output)
      'amber'
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

  def self.parse_go_testing(output)
    return :red   if /FAIL/.match(output)
    return :green if /PASS/.match(output)
    return :amber
  end

  def self.parse_cassert(output)
    return :red   if /(.*)Assertion(.*)failed./.match(output)
    return :green if /All tests passed/.match(output)
    return :amber
  end

  def self.parse_google_test(output)
    return :red   if /\[  FAILED  \]/.match(output)
    return :green if /\[  PASSED  \]/.match(output)
    return :amber
  end

  def self.parse_ruby_rspec(output)
    return :red   if /\A(\.)*F/.match(output)
    return :green if /\A(\.)+$/.match(output)
    return :amber
  end

  def self.parse_nunit(output)
    return :red   if /^Errors and Failures\:/.match(output)
    return :green if /^Tests run: (\d*), Errors: 0, Failures: 0/.match(output)
    return :amber
  end

  #-------------------------------------------------

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

  def self.parse_ruby_test_unit(output)
    ruby_pattern = Regexp.new('^(\d*) tests, (\d*) assertions, (\d*) failures, (\d*) errors')
    if match = ruby_pattern.match(output)
      return :amber if match[4] != '0'
      return :red   if match[3] != '0'
      return :green
    else
      return :amber
    end
  end

  def self.parse_ruby_approvals(output)
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
      if match[1] != "0"
        :green
      else # treat zero passes as a fail
        :red
      end
    else
      amber_pattern0 = Regexp.new('groovyc: command not found')
      amber_pattern1 = Regexp.new('groovy\.lang')
      amber_pattern2 = Regexp.new('MultipleCompilationErrorsException')
      if amber_pattern0.match(output) ||
         amber_pattern1.match(output) ||
         amber_pattern2.match(output)
        :amber
      else
        :red
      end
    end
  end

  def self.parse_hunit(output)
    if output =~ /Counts \{cases = (\d+), tried = (\d+), errors = (\d+), failures = (\d+)\}/
      if $3.to_i != 0
        :amber
      elsif $4.to_i != 0
        :red
      else
        :green
      end
    else
      :amber
    end
  end

  def self.parse_clojure_test(output)
    syntax_error_pattern = /Exception in thread/
    ran_pattern = /Ran (\d+) tests containing (\d+) assertions.(\s*)(\d+) failures, (\d+) errors./
    if syntax_error_pattern.match(output)
      :amber
    elsif output.scan(ran_pattern).any? { |res| res[3] != "0" || res[4] != "0" }
      :red
    elsif output.scan(ran_pattern).any? { |res| res[3] == "0" && res[4] == "0" }
      :green
    else
      :amber
    end
  end

  def self.parse_jasmine(output)
    jasmine_pattern = /(\d+) tests?, (\d+) assertions?, (\d+) failures?/
    if jasmine_pattern.match(output)
      return $3 == "0" ? :green : :red
    else
      :amber
    end
  end

  def self.parse_scala_test(output)
    scala_pattern = /Tests: succeeded (\d+), failed (\d+), ignored (\d+), pending (\d+)/
    if scala_pattern.match(output)
      return $2 == "0" ? :green : :red
    else
      :amber
    end
  end

end
