
require 'test_runner_helper.rb'
require 'Locking'
require 'Files'

class Avatar

  include MakeTimeHelper
  include TestRunnerHelper
  include Files
  include Locking
  include RunTestsOutputParserHelper
  
  def self.names
    %w( alligator buffalo cheetah elephant frog giraffe hippo lion raccoon snake wolf zebra 
        gopher koala squirrel moose bear bat camel lemur panda gorilla deer kangaroo )
  end

  def initialize(dojo, name) 
    @dojo = dojo
    @name = name

    if !File.exists? folder
      Dir::mkdir(folder)
      file_write(pathed(Increments_filename), [])
   
      Dir::mkdir(sandbox)
      kata = @dojo.kata
      kata.hidden_pathnames.each do |hidden_pathname|
        system("cp '#{hidden_pathname}' '#{sandbox}'") 
      end
      kata.visible_files.each do |filename,file|
        save_file(sandbox, filename, file)
      end

      kata.manifest[:visible_files]['output'] = 
        {
          :content => initial_output_text,
          :caret_pos => 0,
          :scroll_top => 0,
          :scroll_left => 0
        }
      kata.manifest[:current_filename] = 'output'
      kata.manifest.delete(:hidden_filenames)
      kata.manifest.delete(:hidden_pathnames)
      file_write(pathed(Manifest_filename), kata.manifest)
      kata.manifest[:visible_files].delete('output')
      
      command  = "cd '#{folder}';" +
                 "git init --quiet;" +
                 "git add '#{Manifest_filename}';" +
                 "git add '#{Increments_filename}';"
      system(command)
      tag = 0
      git_commit_tag(kata.visible_files, tag)
    end
  end
  
  def name
    @name
  end

  def increments(tag = nil)
    io_lock(folder) { locked_increments(tag) }
  end
  
  def manifest(tag = nil)
    io_lock(folder) do
      tag ||= most_recent_tag      
      command  = "cd #{folder};" +
                 "git show #{tag}:#{Manifest_filename}"
      eval popen_read(command) 
    end
  end
  
  def auto_post_message()
    # this is called from kata_controller.run_tests
    all_incs = Increment.all(increments)
    @dojo.post_message(name, "#{name} just passed their first test") if just_passed_first_test?(all_incs)
    @dojo.post_message(name, "looks like #{name} is on a hot refactoring streak!") if refactoring_streak?(all_incs)
  end
  
  def just_passed_first_test?(increments)
    increments.count { |inc| inc.passed? } == 1 and increments.last.passed?
  end
  
  def refactoring_streak?(increments)
    streak_count = 0
    reversed = increments.reverse
    while streak_count < reversed.length && reversed[streak_count].passed?
      streak_count += 1
    end
    streak_count != 0 && streak_count % 5 == 0
  end
  
  def auto_post_message_if_reluctant_to_test(messages)
    # this is called from kata_controller.heartbeat
    all_incs = Increment.all(increments)
    if reluctant_to_run_tests?(all_incs, messages)
      @dojo.post_message(name, "looks like #{name} is reluctant to run tests", :test_reluctance)
    else
    end
  end
  
  def reluctant_to_run_tests?(increments, messages)
    relevant_messages = messages.select do |message|
      message[:type] == :test_reluctance && 
        message[:sender] == name &&
          DateTime.new(*message[:created]) > 10.minutes.ago
    end
    return false unless relevant_messages.empty?
    !increments.empty? and increments.last.old?
  end
  
  def run_tests(manifest, the_kata = @dojo.kata)
    # parameter 2 is needed only for test/functional/run_tests_timeout_tests.rb
    io_lock(folder) do
      output = avatar_run_tests(self, the_kata, manifest)      
      test_info = parse(self, the_kata, output)
      
      incs = locked_increments     
      incs << test_info
      test_info[:time] = make_time(Time::now)
      test_info[:number] = incs.length
      file_write(pathed(Increments_filename), incs)
      manifest[:output] = output
      manifest[:visible_files]['output'][:content] = output
      file_write(pathed(Manifest_filename), manifest)
      
      tag = incs.length
      git_commit_tag(manifest[:visible_files], tag)
    end
  end

  def folder
    @dojo.folder + '/' + name
  end
  
  def sandbox
    pathed('sandbox')
  end

  # Stop gap till diff-history is public and dojos are unnamed
  # Older dojos have fileset.rb file per avatar, the contents of
  # this file are { 'language' => 'C', ... }
  # Newer dojos (since the switch to a single kata.language per dojo)
  # do not have a fileset.rb file per avatar but they do have a 
  # manifest.rb file at the dojo folder level, the contents of
  # this file are { :language => 'C', ... }
  def language
    filesets_manifest[:language] || filesets_manifest['language']
  end

  def kata_name
    filesets_manifest[:kata] || filesets_manifest['kata']  
  end
  
  # Stop gap till diff-history is public and dojos are unnamed
  def tab
    tab_manifest = eval IO.read(@dojo.filesets_root + '/language/' + language + '/manifest.rb')
    " " * (tab_manifest[:tab_size] || 4)
  end
  
private
  
  # Stop gap till diff-history is public and dojos are unnamed
  def filesets_manifest
    # Have to allow resumption of dojos before dojos were
    # single kata x language. 
    filename = folder + '/filesets.rb'
    if !File.exists? filename 
      filename = @dojo.folder + '/manifest.rb'
    end
    eval IO.read(filename)    
  end

  def pathed(filename)
    folder + '/' + filename
  end

  Increments_filename = 'increments.rb'
  
  Manifest_filename = 'manifest.rb'

  def initial_output_text
    [ 
      '',
      '  Click the Run Tests button (above). The output will appear here.',
      '  A traffic-light will also appear:',
      '     (o) red   - the tests ran but one or more failed',
      '     (o) amber - the tests could not be run',
      '     (o) green - the tests ran and all passed',
      '  Click any traffic light to view its diff.',
      '',
      "  Click a filename (left) to edit it here.",
      '',
      '  Click the Post button (left) to send a message to everyone.'
    ].join("\n")
  end

  def most_recent_tag
    command  = "cd #{folder};" +
               "git tag|sort -g"
    eval popen_read(command)    
  end
  
  def git_commit_tag(visible_files, n)
    command = "cd '#{folder}';"
    visible_files.each do |filename,|
      command += "git add '#{sandbox}/#{filename}';"
    end
    command += "git commit -a -m '#{n}' --quiet;"
    command += "git tag -m '#{n}' #{n} HEAD;"
    system(command)   
  end
  
  def locked_increments(tag = nil)
    if tag == nil
      eval IO.read(pathed(Increments_filename))
    else
      command  = "cd #{folder};" +
                 "git show #{tag}:#{Increments_filename}"
      eval popen_read(command)
    end
  end

end


