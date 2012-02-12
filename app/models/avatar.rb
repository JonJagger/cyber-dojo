
require 'test_runner_helper.rb'
require 'Locking'
require 'Files'
require 'Messages'

class Avatar

  include MakeTimeHelper
  include TestRunnerHelper
  include Files
  include Locking
  include RunTestsOutputParserHelper
  include Messages
  
  def self.names
    %w(
      alligator buffalo cheetah deer
      elephant frog gorilla hippo
      koala lion moose panda
      raccoon snake wolf zebra
    )
  end

  def initialize(dojo, name) 
    @dojo = dojo
    @name = name

    if !File.exists? folder
      Dir::mkdir(folder)   
      Dir::mkdir(sandbox)
      kata = @dojo.kata
      kata.hidden_pathnames.each do |hidden_pathname|
        system("cp '#{hidden_pathname}' '#{sandbox}'") 
      end
      kata.visible_files.each do |filename,file|
        save_file(sandbox, filename, file)
      end
      
      kata.manifest[:output] = ''
      kata.manifest[:current_filename] = 'instructions'
      kata.manifest.delete(:hidden_filenames)
      kata.manifest.delete(:hidden_pathnames)
      file_write(pathed(Manifest_filename), kata.manifest)
      file_write(pathed(Increments_filename), [ ])
      
      command  = "cd '#{folder}';" +
                 "git init --quiet;" +
                 "git add '#{Manifest_filename}';" +
                 "git add '#{Increments_filename}';"
      system(command)
      tag = 0
      git_commit_tag(kata.visible_files, tag)
    end
  end
  
  def dojo
    @dojo
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
  
  def post_run_test_messages()
    MessageAutoPoster.new(self).post_run_test_messages()
  end
  
  def post_heartbeat_messages()
    MessageAutoPoster.new(self).post_heartbeat_messages()
  end
    
  def run_tests(manifest, the_kata = @dojo.kata)
    # parameter 2 is needed only for test/functional/run_tests_timeout_tests.rb
    incs = [ ]
    io_lock(folder) do
      output = avatar_run_tests(self, the_kata, manifest)      
      test_info = parse(self, the_kata, output)
      
      incs = locked_increments     
      incs << test_info
      test_info[:time] = make_time(Time::now)
      test_info[:number] = incs.length
      manifest[:output] = output
      save_run_tests_outcomes(incs, manifest)
    end
    incs
  end

  def folder
    @dojo.folder + '/' + name
  end
  
  def sandbox
    pathed('sandbox')
  end

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
  
  def tab
    tab_manifest = eval IO.read(@dojo.filesets_root + '/language/' + language + '/manifest.rb')
    " " * (tab_manifest[:tab_size] || 4)
  end
  
private
  
  def save_run_tests_outcomes(increments, manifest)
    file_write(pathed(Increments_filename), increments)
    file_write(pathed(Manifest_filename), manifest)
    tag = increments.length
    git_commit_tag(manifest[:visible_files], tag)
  end
  
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


