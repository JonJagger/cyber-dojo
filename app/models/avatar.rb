
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
    %w( alligator buffalo cheetah elephant frog giraffe hippo lion raccoon snake wolf zebra )
  end

  def initialize(dojo, name) 
    @dojo = dojo
    @name = name

    if File.exists?(pathed(Filesets_filename))
      @filesets = eval IO.read(pathed(Filesets_filename))
    else
      @filesets = dojo.filesets
      Dir::mkdir(folder)
      file_write(pathed(Filesets_filename), @filesets)
      file_write(pathed(Increments_filename), [])
   
      Dir::mkdir(sandbox)
      kata = Kata.new(@dojo.filesets_root, @filesets)
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
                 "git add '#{Filesets_filename}';" +
                 "git add '#{Increments_filename}';"
      system(command)
      tag = 0
      git_commit_tag(kata.visible_files, tag)
    end
  end
  
  def name
    @name
  end

  def kata
    Kata.new(@dojo.filesets_root, @filesets)
  end
   
  def increments(tag = nil)
    io_lock(folder) { locked_increments(tag) }
  end
  
  def manifest(tag = nil)
    result = nil
    io_lock(folder) do
      tag ||= most_recent_tag      
      command  = "cd #{folder};" +
                 "git show #{tag}:#{Manifest_filename}"
      result = eval popen_read(command) 
    end
    result    
  end
  
  def run_tests(manifest, the_kata = kata)
    incs = [] 
    io_lock(folder) do
      output = avatar_run_tests(self, the_kata, manifest)
      manifest[:output] = output
      test_info = parse(self, the_kata, output)
      
      incs = locked_increments     
      incs << test_info
      test_info[:time] = make_time(Time::now)
      test_info[:number] = incs.length
      file_write(pathed(Increments_filename), incs)

      file_write(pathed(Manifest_filename), manifest)
      
      tag = incs.length
      git_commit_tag(manifest[:visible_files], tag)
    end
    incs
  end

  def folder
    @dojo.folder + '/' + name
  end
  
  def sandbox
    pathed('sandbox')
  end

private

  def pathed(filename)
    folder + '/' + filename
  end

  Increments_filename = 'increments.rb'
  
  Filesets_filename = 'filesets.rb'
  
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


