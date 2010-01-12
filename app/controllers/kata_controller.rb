
class KataController < ApplicationController

  def help
    @title = "Cyber Dojo : Kata Help"
    @manifest = 
    { 
      :visible_files =>  #TODO: make more realistic
      {        
        'unsplice.h' => { :content => 'void unsplice(char * line);' },
        'unsplice.c' => { :content => '#include "unsplice.h"' },
      },
      :language => 'c',
    }
    @editable = true
  end

  def start
    @kata_id = params[:kata_id]
    @avatar = params[:avatar]
    @title = "Cyber Dojo : Kata " + @kata_id + ", " + @avatar
    kata = KataModel.new(@kata_id)

    catalogue = eval IO.read(kata.folder + '/' + 'kata_manifest.rb')
    manifest_folder = 'kata_catalogue' + '/' + catalogue[:language] + '/' + catalogue[:exercise]
    @manifest = eval IO.read(manifest_folder + '/' + 'exercise_manifest.rb')
    @manifest[:visible_files] = kata.exercise.visible_files
    run_tests_output = @manifest[:visible_files]['run_tests_output'][:content]
    test_log = parse_run_test_output(@manifest, run_tests_output.to_s)

    avatar = kata.avatar(@avatar)

    all_increments = []
    File.open(kata.folder, 'r') do |f|
      flock(f) do |lock|
        all_increments = avatar.read_most_recent(@manifest, test_log)
      end
    end

    @increments = limited(all_increments)
    @shown_increment_number = @increments.last[:number] + 1
    @outcome = @increments.last[:outcome].to_s
    @editable = true
  end

  def run_tests
    @kata_id = params[:kata_id]
    @avatar = params[:avatar]
    kata = KataModel.new(@kata_id)

    @manifest = eval params['manifest.rb_div'] # load from web page
    @manifest[:visible_files].each { |filename,file| file[:content] = params[filename] } 

    avatar = kata.avatar(@avatar)

    all_increments = []
    File.open(kata.folder, 'r') do |f|
      flock(f) do |lock|
        @run_tests_output = do_run_tests(avatar.folder, kata.exercise.folder, @manifest)
        @manifest[:visible_files]['run_tests_output'][:content] = @run_tests_output
        test_info = parse_run_test_output(@manifest, @run_tests_output.to_s)
        @outcome = test_info[:outcome].to_s
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
    kata = KataModel.new(@kata_id)
    kata.avatars.each { |avatar| @avatars[avatar.name] = avatar.increments }
  end

  def see_one_increment
    @kata_id = params[:id]
    @avatar = params[:avatar]
    increment_number = params[:increment]
    @title = "Cyber Dojo : Kata " + @kata_id + "," + @avatar + ", increment " + increment_number

    path = 'katas' + '/' + @kata_id + '/' + @avatar + '/' + increment_number + '/' + 'manifest.rb'
    @manifest = eval IO.read(path)

    kata = KataModel.new(@kata_id)
    avatar = kata.avatar(@avatar)
    all_increments = avatar.increments
    one_increment = all_increments[increment_number.to_i]
    @shown_increment_number = one_increment[:number]
    @outcome = one_increment[:outcome].to_s
    @editable = false
  end

private

  def limited(increments)
    max_increments_displayed = 29
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
    # Run make, capturing stdout _and_ stderr    
    # popen runs its command as a subprocess
   # TODO: run as a user with only execute rights; maybe using sudo -u
    run_tests_output = IO.popen("cd #{sandbox}; ./kata.sh 2>&1").readlines
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
    run_tests_output = [ "run-tests stopped as it did not finish within #{max_seconds} seconds" ]
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
  File.chmod(file[:permissions], path) if file[:permissions]
end

# When editArea is used in the is_multi_files:true
# mode then the setting replace_tab_by_spaces: applies
# to ALL tabs (if set) or NONE of them (if not set).
# If it is not set then the default tab-width of the
# operating system seems to apply, which in Ubuntu
# is 8 spaces. There appears to be no way to alter the 
# tab-width in Ubuntu or in Firefox. Hence if you
# want tabs to expand to 4 spaces, as I do, you have to
# use replace_tab_by_spaces:=4 setting. This creates
# a problem for makefiles since they are tab sensitive.
# Hence this special filter, just for makefiles to 
# convert 4 leading spaces to a tab character.
def makefile_filter(name, content)
  if name.downcase == 'makefile'
    lines = []
    newline = Regexp.new('[\r]?[\n]')
    content.split(newline).each do |line|
      line = "\t" + line[4 .. line.length-1] if line[0..3] == "    "
      lines.push(line)
    end
    content = lines.join("\r\n")
  end
  content
end

#=========================================================================

def parse_run_test_output(manifest, output)
  inc = eval "parse_#{manifest[:language]}_#{manifest[:unit_test_framework]}(output)"
  if Regexp.new("run-tests stopped").match(output)
    inc[:info] = "run-tests stopped"
  end
  inc
end

def parse_ruby_test_unit(output)
  ruby_pattern = Regexp.new('^(\d*) tests, (\d*) assertions, (\d*) failures, (\d*) errors')
  if match = ruby_pattern.match(output)
    if match[3] == "0" 
      inc = { :outcome => :passed, :info => match[2] }
    else
      inc = { :outcome => :failed, :info => match[3] }
    end
  else
    inc = { :outcome => :error, :info => "syntax error" }
  end
end

def parse_java_junit(output)
  junit_pass_pattern = Regexp.new('^OK \((\d*) test')
  if match = junit_pass_pattern.match(output)
    if match[1] != "0" 
      inc = { :outcome => :passed, :info => match[1] }
    else
      # treat zero passes as a fail
      inc = { :outcome => :failed, :info => '0' }
    end
  else
    junit_fail_pattern = Regexp.new('^Tests run: (\d*),  Failures: (\d*)')
    if match = junit_fail_pattern.match(output)
      inc = { :outcome => :failed, :info => match[2] }
    else
      inc = { :outcome => :error, :info => "syntax error" }
    end
  end
end

def parse_cpp_tequila(output)
  parse_c_tequila(output)
end

def parse_c_tequila(output)
  tequila_parse_pattern = Regexp.new('^TEQUILA ([A-Z]*): (\d*) passed, (\d*) failed')
  if match = tequila_parse_pattern.match(output) 
    case match[1]
    when 'FAILED'
      inc = { :outcome => :failed, :info => match[3] }
    when 'PASSED'
      inc = { :outcome => :passed, :info => match[2] }
    else
      #TODO: Error - tequila has changed its output format 
      # inc = { :outcome => :exception, :info => 'tequila format change' } ???
      inc = { :outcome => :error, :info => 'tequila format change' }
    end
  else
    inc = { :outcome => :error, :info => "syntax error" }
  end
end

def diff_time_to_s(past, now)
  days,hours,mins,secs = *dhms((now - past).to_i)
  return dhms_display(days,hours,mins,secs)
end

SECONDS_PER_MINUTE = 60
MINUTES_PER_HOUR = 60
HOURS_PER_DAY = 24

def dhms(value)
  seconds,value = mod_div(value, SECONDS_PER_MINUTE)
  minutes,value = mod_div(value, MINUTES_PER_HOUR)
    hours,days  = mod_div(value, HOURS_PER_DAY)
  [days, hours, minutes, seconds]
end

def mod_div(val, n)
  [val % n, val / n]
end

SEP = ":"

def dhms_display(days, hours, mins, secs)
  return  mins.to_s + SEP + lead_zero(secs)  if days == 0 and hours == 0
  return hours.to_s + SEP + lead_zero(mins)  + SEP + lead_zero(secs) if days == 0
  return  days.to_s + SEP + lead_zero(hours) + SEP + lead_zero(mins) + SEP + lead_zero(secs) 
end

def lead_zero(value)
  (value < 10 ? '0' : '') + value.to_s    
end


