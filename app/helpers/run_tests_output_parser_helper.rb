
module RunTestsOutputParserHelper

  #  :failed - this means the tests ran but at least one failed
  #  :error  - this means the tests could not be run (eg syntax error)
  #  :passed - this means the tests ran and all passed
  
  def parse(avatar, kata, output)
    inc = { :run_tests_output => output }
    if Regexp.new("Terminated by the CyberDojo server after").match(output)
      inc[:outcome] = :error
    else
      inc[:outcome] = eval "parse_#{kata.unit_test_framework}(output)"
    end
    inc
  end

  def parse_node(output)
    failed_pattern = Regexp.new('AssertionError')
    error_pattern = Regexp.new('Error')
    if failed_pattern.match(output)
      :failed
    elsif error_pattern.match(output)
      :error
    else
      :passed
    end
  end

  def parse_php_unit(output)
    passed_pattern = Regexp.new('OK \(')
    failed_pattern = Regexp.new('FAILURES!')
    if passed_pattern.match(output)
	    :passed
    elsif failed_pattern.match(output)
	    :failed
    else
	    :error
    end
  end

  def parse_perl_test_simple(output)
    passed_pattern = Regexp.new('All tests successful')
    error_pattern = Regexp.new('syntax error')
    if passed_pattern.match(output)
	    :passed
    elsif error_pattern.match(output)
	    :error
    else
	    :failed
    end
  end

  def parse_js_test_simple(output)
    error_pattern = Regexp.new('Exception in thread "main" org.mozilla')
    failed_pattern = Regexp.new('FAILED:assertEqual')
    if error_pattern.match(output)
	    :error
    elsif failed_pattern.match(output)
	    :failed
    else
	    :passed
    end
  end

  def parse_eunit(output) 
    failed_pattern = Regexp.new('Failed: ')
    passed_pattern = Regexp.new('passed.')
    if failed_pattern.match(output)
	    :failed
    elsif passed_pattern.match(output)
	    :passed
    else
	    :error
    end
  end
	
  def parse_python_unittest(output) 
    failed_pattern = Regexp.new('FAILED \(failures=')
    passed_pattern = Regexp.new('OK')
    if failed_pattern.match(output)
	    :failed
    elsif passed_pattern.match(output)
	    :passed
    else
	    :error
    end
  end
	
  def parse_cassert(output)
    failed_pattern = Regexp.new('(.*)Assertion(.*)failed.')
    syntax_error_pattern = Regexp.new(':(\d*): error')
    make_error_pattern = Regexp.new('^make:')
    if failed_pattern.match(output)
      :failed
    elsif make_error_pattern.match(output)
      :error
    elsif syntax_error_pattern.match(output)
      :error
    else
      :passed
    end
  end

  def parse_ruby_test_unit(output)
    # If a player creates a cyberdojo.sh file with two lines
    # ruby test_gapper.rb
    # ruby test_git_diff.rb
    # then it's possible the first one will pass and the second
    # one will have a failure. The regex below won't detect that.
    # Not sure if this is a bug or not. In a dojo should you be
    # doing a simple small kata which should only have one test 
    # class?

    ruby_pattern = Regexp.new('^(\d*) tests, (\d*) assertions, (\d*) failures, (\d*) errors')
    if match = ruby_pattern.match(output)
      if match[4] != "0"
        :error
      elsif match[3] != "0"
        :failed
      else
        :passed
      end
    else
      :error
    end
  end

  def parse_nunit(output)
    nunit_pattern = /^Tests run: (\d*)(, Errors: (\d+)), Failures: (\d*)/
    if output =~ nunit_pattern
      puts "nunit $2 = #$2, $3 = #$3, $4 = #$4"
      if $4 == "0" and ($3.blank? or $3 == "0")
        :passed
      else
        :failed
      end
    else
      :error
    end
  end

  def parse_junit(output)
    junit_pass_pattern = Regexp.new('^OK \((\d*) test')
    if match = junit_pass_pattern.match(output)
      if match[1] != "0" 
        :passed 
      else # treat zero passes as a fail
        :failed 
      end
    else
      junit_fail_pattern = Regexp.new('^Tests run: (\d*),  Failures: (\d*)')
      if match = junit_fail_pattern.match(output)
        :failed 
      else
        :error
      end
    end
  end

  def parse_jasmine(output)
     jasmine_pattern = /(\d+) test, (\d+) assertion, (\d+) failure/
     if jasmine_pattern.match(output)
        return $3 == "0" ? :passed : :failed
     else
        :error
     end
  end

end


