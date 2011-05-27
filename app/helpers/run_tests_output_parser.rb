
module RunTestsOutputParser

  def self.parse(avatar, kata, output)
    inc = { :run_tests_output => output }
    if Regexp.new("Execution terminated after ").match(output)
      inc[:outcome] = :failed
    else
      inc[:outcome] = eval "parse_#{kata.unit_test_framework}(output)"
    end
    inc
  end

private

	def self.parse_php_unit(output)
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

	def self.parse_perl_test_simple(output)
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

	def self.parse_js_test_simple(output)
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

	def self.parse_python_unittest(output) 
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
	
  def self.parse_cassert(output)
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

  def self.parse_ruby_test_unit(output)
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

  def self.parse_nunit(output)
    nunit_pattern = Regexp.new('^Tests run: (\d*), Failures: (\d*)')
    if match = nunit_pattern.match(output)
      if match[2] == "0"
        :passed
      else
        :failed
      end
    else
      :error
    end
  end

  def self.parse_junit(output)
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

end


