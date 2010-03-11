
class KataController < ApplicationController

  def start
    @kata_id = params[:kata_id]
    @avatar = params[:avatar]
    @title = "Cyber Dojo : Kata " + @kata_id + ", " + @avatar
    kata = Kata.new(@kata_id)

    @manifest = load_starting_manifest(kata)
    avatar = kata.avatar(@avatar)
    all_increments = []
    File.open(kata.folder, 'r') do |f|
      flock(f) do |lock|
        all_increments = avatar.read_most_recent(@manifest)
      end
    end
    
    @increments = limited(all_increments)
    if @increments.length == 0
      @shown_increment_number = 0
    else
      @shown_increment_number = @increments.last[:number] + 1
    end
    @editable = true
  end

  def run_tests
    @kata_id = params[:kata_id]
    @avatar = params[:avatar]
    kata = Kata.new(@kata_id)
    avatar = kata.avatar(@avatar)

    # load from web page, eg :hidden_files, :language, :unit_test_framework
    @manifest = eval params['manifest.rb'] 

    # reload max_run_tests_duration on each increment so it can be
    # altered by the sensei during the kata if necessary
    @manifest[:max_run_tests_duration] = kata.max_run_tests_duration

    # filenames in the file-list may have been renamed or deleted so reload visible_files
    @manifest[:visible_files] = {}
    filenames = params['visible_filenames_container'].strip.split(';')
    filenames.each do |filename|
      filename.strip!
      if (filename != "")
        @manifest[:visible_files][filename] = {}
        # TODO: creating a new file and then immediately deleting it
        #       causes params[filename] to be be nil for some reason
        #       I haven't yet tracked down.
        if content = params[filename]
          @manifest[:visible_files][filename][:content] = content.split("\r\n").join("\n")
        end
      end
    end

    all_increments = []
    File.open(kata.folder, 'r') do |f|
      flock(f) do |lock|
        @run_tests_output = do_run_tests(avatar.folder, kata.exercise.folder, @manifest)
        test_info = parse_run_tests_output(@manifest, @run_tests_output)
        test_info[:prediction] = params['run_tests_prediction']
        all_increments = avatar.save(@manifest, test_info)
      end
    end

    @increments = limited(all_increments)
    @shown_increment_number = @increments.last[:number] + 1
    @editable = true

    respond_to do |format|
      format.js if request.xhr?
    end
  end

  def see_all_increments
    @kata_id = params[:id]
    @title = "Cyber Dojo : Kata " + @kata_id + ", all increments"
    @avatars = {}
    kata = Kata.new(@kata_id)
    kata.avatars.each { |avatar| @avatars[avatar.name] = avatar.increments }
    @editable = false
  end

  def see_one_increment
    @kata_id = params[:id]
    kata = Kata.new(@kata_id)
    @avatar = params[:avatar]
    avatar = kata.avatar(@avatar)
    all_increments = avatar.increments

    if params[:increment]
      load_increment_manifest(params[:increment])
    elsif all_increments.length != 0
      load_increment_manifest(all_increments.last[:number].to_s)
    else
      @title = "Cyber Dojo : Kata " + @kata_id + "," + @avatar
      @manifest = kata.exercise.manifest
      @shown_increment_number = "0"
    end

    @increments = limited(all_increments)
    @editable = false
  end

private

  def load_increment_manifest(increment_number)
    @title = "Cyber Dojo : Kata " + @kata_id + "," + @avatar + ", increment " + increment_number
    path = 'katas' + '/' + @kata_id + '/' + @avatar + '/' + increment_number + '/' + 'manifest.rb'
    @manifest = eval IO.read(path)
    @shown_increment_number = increment_number
  end

  def load_starting_manifest(kata)
    catalogue = eval IO.read(kata.folder + '/' + 'kata_manifest.rb')
    manifest_folder = 'kata_catalogue' + '/' + catalogue[:language] + '/' + catalogue[:exercise]
    manifest = eval IO.read(manifest_folder + '/' + 'exercise_manifest.rb')
    manifest[:language] = catalogue[:language]
    # this is to load file content
    manifest[:visible_files] = kata.exercise.visible_files    
	# load editor setting or defaults
    manifest[:font_size] ||= 14;
    manifest[:font_family] ||= 'monospace';
    manifest[:font_weight] ||= 'normal';
    manifest[:color] ||= 'white';
    manifest[:background_color] ||= '#686868';
    manifest
  end

  def limited(increments)
    max_increments_displayed = 54
    len = [increments.length, max_increments_displayed].min
    increments[-len,len]
  end

end

#=========================================================================

def do_run_tests(dst_folder, src_folder, manifest)
  # Save current files to sandbox
  sandbox = dst_folder + '/' + 'sandbox'
  system("rm -r #{sandbox}")
  make_dir(sandbox)
  manifest[:visible_files].each { |filename,file| save_file(sandbox, filename, file) }
  manifest[:hidden_files].each_key { |filename| system("cp #{src_folder}/#{filename} #{sandbox}") }

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
  max_seconds = manifest[:max_run_tests_duration]
  max_seconds.times do 
    sleep(1)
    break if sandbox_thread.status == false 
  end
  # If tests haven't finished after max_seconds assume 
  # they are stuck in an infinite loop and kill the thread
  if sandbox_thread.status != false 
    sandbox_thread.kill 
    run_tests_output = [ "execution did not finish within #{max_seconds} seconds" ]
  end
  run_tests_output
end

def save_file(foldername, filename, file)
  path = foldername + '/' + filename
  # no need to lock when writing these files. They are write-once-only
  File.open(path, 'w') do |fd|
    filtered = makefile_filter(filename, file[:content])
    fd.write(filtered)
  end
  # .sh files (for example) need execute permissions
  File.chmod(0755, path) if filename =~ /\.sh/    
end

# Tabs are a problem for makefiles since they are tab sensitive.
# You can't enter a tab in a plain textarea hence this special filter, 
# just for makefiles to convert leading spaces to a tab character. 
def makefile_filter(name, content)
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

#=========================================================================

def parse_run_tests_output(manifest, output)
  so = output.to_s
  inc = eval "parse_#{manifest[:language]}_#{manifest[:unit_test_framework]}(so)"
  if Regexp.new("execution did not finish within").match(so)
    inc[:info] = so
    inc[:outcome] = :timeout
  else
    # put newlines into form that works in faked tool-tip
    inc[:info] = output.split("\n").join("<br/>")
  end
  inc
end

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

