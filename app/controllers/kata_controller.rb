
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
    kata = KataModel.new(@kata_id)
    avatar = kata.avatar(@avatar)

    catalogue = eval IO.read(kata.folder + '/' + 'kata_manifest.rb')
    manifest_folder = 'kata_catalogue' + '/' + catalogue[:language] + '/' + catalogue[:exercise]
    @manifest = eval IO.read(manifest_folder + '/' + 'exercise_manifest.rb')

    exercise = kata.exercise

    @title = "Cyber Dojo : Kata " + @kata_id + ", " + @avatar
    @visible_files = exercise.initial_files
    @manifest[:visible_files] = @visible_files
    @editable = true
    run_tests_output = @visible_files['run_tests_output'][:content]
    test_log = parse_run_test_output(exercise, run_tests_output.to_s)
    all_increments = avatar.read_most_recent_files(@visible_files, test_log, @manifest)
    @increments = limited(all_increments)
    @outcome = @increments.last[:outcome].to_s
  end

  def run_tests
    @kata_id = params[:kata_id]
    @avatar = params[:avatar]
    kata = KataModel.new(@kata_id)

    @manifest = eval params['manifest.rb_div'] # load from web page
    @manifest[:visible_files].each { |filename,file| file[:content] = params[filename] } 

    exercise = kata.exercise 
    avatar = kata.avatar(@avatar)

    @run_tests_output = 
      do_run_tests(
        avatar.folder,
        @manifest[:visible_files], 
        exercise.folder, 
        @manifest[:hidden_files], 
        exercise.max_run_tests_duration)

    @manifest[:visible_files]['run_tests_output'][:content] = @run_tests_output
    test_info = parse_run_test_output(exercise, @run_tests_output.to_s)
    @outcome = test_info[:outcome].to_s
    increments = avatar.save({}, test_info, @manifest)
    @increments = limited(increments)
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
    @increments = [ all_increments[increment_number.to_i] ]
    @outcome = @increments.last[:outcome].to_s
    @editable = false
  end

private

  def limited(increments)
    max_increments_displayed = 20
    len = [increments.length, max_increments_displayed].min
    increments[-len,len]
  end

end

#=========================================================================

def do_run_tests(dst_folder, visible_files, src_folder, hidden_files, max_seconds)
  # Save current files to sandbox
  sandbox = dst_folder + '/' + 'sandbox'
  system("rm -r #{sandbox}")
  make_dir(sandbox)
  visible_files.each { |filename,file| save_file(sandbox, filename, file) }
  hidden_files.each_key { |filename| system("cp #{src_folder}/#{filename} #{sandbox}") }
  # Run tests in sandbox in dedicated thread
  run_tests_output = []
  sandbox_thread = Thread.new do
    # Run make, capturing stdout _and_ stderr    
    # popen runs its command as a subprocess
   # TODO: run as a user with only execute rights; maybe using sudo -u
    run_tests_output = IO.popen("cd #{sandbox}; ./kata.sh 2>&1").readlines
  end
  # Build and run tests has max_seconds to complete
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

def parse_run_test_output(exercise, output)
  inc = eval "parse_#{exercise.language}_#{exercise.unit_test_framework}(output)"
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


