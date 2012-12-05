
require 'Files'
require 'Folders'
require 'Locking'
require 'make_time_helper'

class Avatar

  include MakeTimeHelper
  
  def self.names
    # no two animals start with the same letter
    %w(
        alligator buffalo cheetah deer
        elephant frog gorilla hippo
        koala lion moose panda
        raccoon snake wolf zebra
      )
  end

  def initialize(kata, name) 
    @kata = kata
    @name = name
    if !File.exists? dir
      Dir::mkdir(dir)   
      Files::file_write(pathed(Manifest_filename), @kata.visible_files)
      Files::file_write(pathed(Increments_filename), [ ])
      command = "git init --quiet;" +
                "git add '#{Manifest_filename}';" +
                "git add '#{Increments_filename}';"
      system(cd_dir(command))
      git_commit_tag(@kata.visible_files, tag = 0)
    end
  end
  
  def kata
    @kata
  end
  
  def name
    @name
  end
      
  def save_run_tests(visible_files, output, inc)
    inc[:time] = make_time(Time.now)
    visible_files['output'] = output
    Locking::io_lock(dir) do
      increments = locked_read(Increments_filename)
      tag = increments.length + 1
      inc[:number] = tag
      Files::file_write(pathed(Increments_filename), increments << inc)
      Files::file_write(pathed(Manifest_filename), visible_files)
      git_commit_tag(visible_files, tag)
    end
  end

  def visible_files(tag = nil)
    unlocked_read(Manifest_filename, tag)
  end

  def increments(tag = nil)
    unlocked_read(Increments_filename, tag)
  end

  def diff_lines(was_tag, now_tag)
    command = cd_dir("git diff --ignore-space-at-eol --find-copies-harder #{was_tag} #{now_tag} sandbox;")
    Files::popen_read(command)
  end
  
private

  def sandbox
    pathed('sandbox')
  end

  def pathed(filename)
    dir + '/' + filename
  end
      
  def dir
    @kata.dir + '/' + name
  end
  
  def git_commit_tag(visible_files, tag)
    # recreate new empty sandbox so deleted files
    # are not in it and so are seen as deleted
    # by the git diff command above
    system("rm -rf #{sandbox}")
    Dir::mkdir(sandbox)
    
    command = ""
    visible_files.each do |filename,content|
      pathed_filename = sandbox + '/' + filename
      Folders::make_folder(pathed_filename)      
      File.open(pathed_filename, 'w') { |file| file.write content }      
      command += "git add '#{pathed_filename}';"
    end
    command += "git commit -a -m '#{tag}' --quiet;"
    command += "git tag -m '#{tag}' #{tag} HEAD;"
    system(cd_dir(command))
  end
  
  def unlocked_read(filename, tag)
    Locking::io_lock(dir) { locked_read(filename, tag) }
  end
  
  def locked_read(filename, tag = nil)
    tag ||= most_recent_tag
    command = cd_dir("git show #{tag}:#{filename}")
    eval Files::popen_read(command)
  end
     
  def most_recent_tag
    command = cd_dir("git tag|sort -g")
    eval Files::popen_read(command)
  end
  
  def cd_dir(command)
    "cd #{dir};" + command
  end
  
  Increments_filename = 'increments.rb'  
  Manifest_filename = 'manifest.rb'

end


