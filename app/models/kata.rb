
class Kata

  def initialize(id, name="")
    @id = id
    @manifest = eval IO.read(folder + '/' + 'kata_manifest.rb')
    @exercise = Exercise.new(self)
    @avatar = Avatar.new(self, name) if name != ""
    @readonly = false
  end

  def id
    @id.to_s
  end

  def readonly
    @readonly
  end

  def readonly=(tf)
    @readonly = tf
  end

  def language
    @manifest[:language].to_s
  end

  def max_run_tests_duration
    @manifest[:max_run_tests_duration].to_i
  end

  def unit_test_framework
    @exercise.unit_test_framework
  end

  def hidden_filenames
    @exercise.hidden_files
  end

  def exercise
    @exercise
  end

  def avatar
    @avatar
  end

  def avatars
    result = []
    Avatar.names.each do |avatar_name|
      path = folder + '/' + avatar_name
      result << Avatar.new(self,avatar_name) if File.exists?(path)
    end
    result
  end

  def run_tests(manifest, prediction)
    File.open(folder, 'r') do |f|
      flock(f) do |lock|
        run_tests_output = TestRunner.run_tests(self, manifest)
        test_info = RunTestsOutputParser.new().parse(self, run_tests_output)
        test_info[:prediction] = prediction
        avatar.save(manifest, test_info)
      end
    end
  end

  def folder
    'katas' + '/' + id
  end

end

#=================================================================

class TestRunner

  def self.run_tests(kata, manifest)
    dst_folder = kata.avatar.folder
    src_folder = kata.exercise.folder

    # Save current files to sandbox
    sandbox = dst_folder + '/' + 'sandbox'
    system("rm -r #{sandbox}")
    make_dir(sandbox)
    manifest[:visible_files].each { |filename,file| save_file(sandbox, filename, file) }
    kata.hidden_filenames.each_key { |filename| system("cp #{src_folder}/#{filename} #{sandbox}") }

    # Run tests in sandbox in dedicated thread
    run_tests_output = []
    sandbox_thread = Thread.new do
      # o) run make, capturing stdout _and_ stderr    
      # o) popen runs its command as a subprocess
      # o) splitting and joining on "\n" should remove any operating 
      #    system differences regarding new-line conventions
      # TODO: run as a user with only execute rights; maybe using sudo -u, or qemu
      run_tests_output = IO.popen("cd #{sandbox}; ./kata.sh 2>&1").read.split("\n").join("\n")
    end

    # Build and run tests has limited time to complete
    kata.max_run_tests_duration.times do
      sleep(1)
      break if sandbox_thread.status == false 
    end
    # If tests didn't finish assume they were stuck in 
    # an infinite loop and kill the thread
    if sandbox_thread.status != false 
      sandbox_thread.kill 
      run_tests_output = [ "execution terminated after #{kata.max_run_tests_duration} seconds" ]
    end

    run_tests_output
  end

private

  def self.save_file(foldername, filename, file)
    path = foldername + '/' + filename
    # no need to lock when writing these files. They are write-once-only
    File.open(path, 'w') do |fd|
      filtered = makefile_filter(filename, file[:content])
      fd.write(filtered)
    end
    # .sh files need execute permissions
    File.chmod(0755, path) if filename =~ /\.sh/    
  end

  # Tabs are a problem for makefiles since they are tab sensitive.
  # You can't enter a tab in a plain textarea hence this special filter, 
  # just for makefiles to convert leading spaces to a tab character. 
  def self.makefile_filter(name, content)
    if name.downcase == 'makefile'
      lines = []
      newline = Regexp.new('[\r]?[\n]')
      content.split(newline).each do |line|
        if stripped = line.lstrip!
          line = "\t" + stripped
        end
        lines.push(line)
      end
      content = lines.join("\n")
    end
    content
  end

end

#=================================================================

class RunTestsOutputParser

  def parse(kata, output)
    so = output.to_s
    inc = eval "parse_#{kata.language}_#{kata.unit_test_framework}(so)"
    if Regexp.new("execution terminated after ").match(so)
      inc[:info] = so
      inc[:outcome] = :timeout
    else
      # put newlines into form that works in faked tool-tip
      inc[:info] = output.split("\n").join("<br/>")
    end
    inc
  end

private

  def parse_ruby_test_unit(output)
    ruby_pattern = Regexp.new('^(\d*) tests, (\d*) assertions, (\d*) failures, (\d*) errors')
    if match = ruby_pattern.match(output)
      if match[3] == "0" 
        inc = { :outcome => :passed }
      else
        inc = { :outcome => :failed }
      end
    else
      inc = { :outcome => :error }
    end
  end

  def parse_csharp_nunit(output)
    nunit_pattern = Regexp.new('^Tests run: (\d*), Failures: (\d*)')
    if match = nunit_pattern.match(output)
      if match[2] == "0"
        inc = { :outcome => :passed }
      else # treat zero passes as a fail
        inc = { :outcome => :failed }
      end
    else
      inc = { :outcome => :error }
    end
  end

  def parse_java_junit(output)
    junit_pass_pattern = Regexp.new('^OK \((\d*) test')
    if match = junit_pass_pattern.match(output)
      if match[1] != "0" 
        inc = { :outcome => :passed }
      else # treat zero passes as a fail
        inc = { :outcome => :failed }
      end
    else
      junit_fail_pattern = Regexp.new('^Tests run: (\d*),  Failures: (\d*)')
      if match = junit_fail_pattern.match(output)
        inc = { :outcome => :failed }
      else
        inc = { :outcome => :error }
      end
    end
  end

  def parse_cpp_assert(output)
    parse_c_assert(output)
  end

  def parse_c_assert(output)
    failed_pattern = Regexp.new('(.*)Assertion(.*)failed.')
    syntax_error_pattern = Regexp.new(':(\d*): error')
    make_error_pattern = Regexp.new('^make:')
    if failed_pattern.match(output)
      inc = { :outcome => :failed }
    elsif make_error_pattern.match(output)
      inc = { :outcome => :error }
    elsif syntax_error_pattern.match(output)
      inc = { :outcome => :error }
    else
      inc = { :outcome => :passed }
    end
  end

end




