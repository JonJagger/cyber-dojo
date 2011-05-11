
require 'file_write.rb'
require 'io_lock.rb'
require 'make_time.rb'

class Avatar

  def self.names
    %w( alligator bat bear buffalo camel cheetah 
        deer elephant frog giraffe gopher gorilla 
        hippo kangaroo koala lemur lion moose 
        panda raccoon snake squirrel wolf zebra )
  end
  
  def initialize(dojo, name, filesets = nil) 
    @dojo = dojo
    io_lock(@dojo.folder) do
      # important to choose random_unused_avatar inside io_lock to prevent
      # more than one computer entering the dojo as the same avatar
      @name = name || random_unused_avatar

      if File.exists?(pathed(Filesets_filename))
        @filesets = eval IO.read(pathed(Filesets_filename))
      else
        @filesets = filesets
        Dir::mkdir(folder)
        file_write(pathed(Filesets_filename), @filesets)
        file_write(pathed(Increments_filename), [])
        # Create sandbox
        Dir::mkdir(sandbox)
        # Copy hidden files from kata fileset 
        # into sandbox ready for future run_tests        
        kata = Kata.new(@dojo.filesets_root, @filesets)
        kata.hidden_pathnames.each do |hidden_pathname|
          system("cp '#{hidden_pathname}' '#{sandbox}'") 
        end
        # Copy visible files into sandbox (needed for diff 0 1)
        kata.visible_files.each do |filename,file|
          TestRunner::save_file(sandbox, filename, file)
        end

        kata.manifest[:output] = initial_output_text
        kata.manifest[:editor_text] = initial_editor_text
        kata.manifest.delete(:hidden_filenames)
        kata.manifest.delete(:hidden_pathnames)
        file_write(pathed(Manifest_filename), kata.manifest)
        
        cmd  = "cd '#{folder}';"
        cmd += "git init --quiet;"
        cmd += "git add '#{Manifest_filename}';"
        cmd += "git add '#{Filesets_filename}';"
        cmd += "git add '#{Increments_filename}';"
        system(cmd)
        tag = 0
        git_commit_tag(kata.visible_files, tag)
      end
    end
  end
  
  def name
    @name
  end

  def kata
    Kata.new(@dojo.filesets_root, @filesets)
  end
   
  def increments
    io_lock(pathed(Increments_filename)) { 
      eval IO.read(pathed(Increments_filename)) 
    }
  end

  def read_manifest(manifest, tag = nil)
    io_lock(folder) do
      cmd  = "cd #{folder};"
      cmd += "git tag|sort -g"
      tag ||= eval IO::popen(cmd).read
      
      cmd  = "cd #{folder};"
      cmd += "git show #{tag}:#{Manifest_filename}"
      read_manifest = eval IO::popen(with_stderr(cmd)).read
      
      manifest[:visible_files] = read_manifest[:visible_files]
      manifest[:current_filename] = read_manifest[:current_filename]
      manifest[:output] = read_manifest[:output]
      manifest[:editor_text] = read_manifest[:editor_text]
      
      cmd  = "cd #{folder};"
      cmd += "git show #{tag}:#{Increments_filename}"
      incs = eval IO::popen(with_stderr(cmd)).read
    end    
  end
  
  def run_tests(manifest)
    the_kata = kata
    incs = [] 
    io_lock(folder) do 
      output = TestRunner::avatar_run_tests(self, the_kata, manifest)
      test_info = RunTestsOutputParser::parse(self, the_kata, output)
      
      incs = increments     
      incs << test_info
      test_info[:time] = make_time(Time::now)
      test_info[:number] = incs.length
      file_write(pathed(Increments_filename), incs)

      manifest[:output] = output
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

  def with_stderr(cmd)
    cmd + " " + "2>&1"
  end

  def pathed(filename)
    folder + '/' + filename
  end

  # The number of entries in this file equals the number
  # of git commits/tags, including zero.
  Increments_filename = 'increments.rb'
  Filesets_filename = 'filesets.rb'
  Manifest_filename = 'manifest.rb'

  def random_unused_avatar
    Avatar::names.select { |name| !File.exists? @dojo.folder + '/' + name }.shuffle[0]
  end

  def initial_editor_text
    [
      '',
      '',
      '',
      " <---- This is the #{@name.capitalize} computer.",
      '',
      '',
      "                                     The status of all computers ---->",
      '                                     periodically updates here.',
      '',
      '',
      ' <---- Click these buttons to create new files,',
      '       rename files, and delete files.',
      '',
      '',
      '',
      ' <---- Click a filename button and it will',
      '       appear here, ready for editing.',      
    ].join("\n")      
  end
  
  def initial_output_text
    [ 
      '',
      '',
      ' <---- Click Run Tests to start. The output will appear here.',
      '',
      '',
      ' <---- A traffic light will also apppear:',
      '',
      '          (o) red    - the tests ran but one or more failed',
      '          (o) yellow - the tests could not be run',
      '          (o) green  - the tests ran and all passed',
      '',
    ].join("\n")
  end

  def git_commit_tag(visible_files, n)
    # I add visible files to the git repository
    # but never the hidden files.
    cmd  = "cd '#{folder}';"
    visible_files.each do |filename,|
      cmd += "git add '#{sandbox}/#{filename}';"
    end
    cmd += "git commit -a -m '#{n}' --quiet;"
    cmd += "git tag -m '#{n}' #{n} HEAD;"
    system(cmd)    
  end
  
end


