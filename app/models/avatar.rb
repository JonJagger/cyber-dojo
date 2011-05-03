
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
      
      if File.exists?(pathed(filesets_filename))
        @filesets = eval IO.read(pathed(filesets_filename))
      else
        @filesets = filesets
        Dir.mkdir(folder)
        file_write(pathed(filesets_filename), @filesets)
        file_write(pathed(increments_filename), [])
        # Create sandbox
        Dir.mkdir(sandbox)
        # Copy hidden files from kata fileset 
        # into sandbox ready for future run_tests        
        kata = Kata.new(@dojo.filesets_root, @filesets)
        kata.hidden_pathnames.each do |hidden_pathname|
          system("cp '#{hidden_pathname}' '#{sandbox}'") 
        end
        # Copy visible files into sandbox (needed for diff 0 1)
        kata.visible_files.each do |filename,file|
          TestRunner.save_file(sandbox, filename, file)
        end

        kata.manifest[:output] = initial_output_text()
        kata.manifest[:editor_text] = initial_editor_text
        kata.manifest.delete(:hidden_filenames)
        kata.manifest.delete(:hidden_pathnames)
        file_write(pathed(manifest_filename), kata.manifest)
        
        cmd  = "cd '#{folder}';"
        cmd += "git init --quiet;"
        cmd += "git add '#{manifest_filename}';"
        cmd += "git add '#{filesets_filename}';"
        cmd += "git add '#{increments_filename}';"
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
    io_lock(pathed(increments_filename)) { eval IO.read(pathed(increments_filename)) }
  end

  def read_manifest(manifest, tag = nil)
    io_lock(folder) do
      tag ||= eval IO.popen("cd #{folder};git tag|sort -g").read
      read_manifest = eval IO.popen("cd #{folder};git show #{tag}:#{manifest_filename} 2>&1").read
      manifest[:visible_files] = read_manifest[:visible_files]
      manifest[:current_filename] = read_manifest[:current_filename]
      manifest[:output] = read_manifest[:output]
      manifest[:editor_text] = read_manifest[:editor_text]
      incs = eval IO.popen("cd #{folder};git show #{tag}:#{increments_filename} 2>&1").read
    end    
  end
  
  def run_tests(manifest)
    the_kata = kata
    incs = [] 
    io_lock(folder) do 
      output = TestRunner.avatar_run_tests(self, the_kata, manifest)
      test_info = RunTestsOutputParser.parse(self, the_kata, output)
      
      incs = increments     
      incs << test_info
      test_info[:time] = make_time(Time.now)
      test_info[:number] = incs.length
      file_write(pathed(increments_filename), incs)

      manifest[:output] = output
      file_write(pathed(manifest_filename), manifest)
      
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

  def filesets_filename
    'filesets.rb'
  end

  def manifest_filename
    'manifest.rb'
  end
  
  def increments_filename
    # The number of entries in this file equals the number
    # of git commits/tags, including zero.
    'increments.rb'
  end

  def random_unused_avatar
    Avatar.names.select { |name| !File.exists? @dojo.folder + '/' + name }.shuffle[0]
  end

  def initial_editor_text
    [
      '',
      '',
      '',
      '',
      " <----- This is the #{@name.capitalize} computer.",
      '',
      '',
      "                                     The status of all computers ---->",
      '                                     periodically updates here.',
      '',
      '',
      ' <----- Click these buttons to create new files,',
      '        rename files, and delete files.',
      '',
      '',
      ' <----- Click a filename button and it will',
      '        appear here, ready for editing.',      
    ].join("\n")      
  end
  
  def initial_output_text
    [ 
      '',
      '',
      ' <----- Click Run Tests to start. The output will appear here.',
      '',
      '',
      ' <----- A traffic light will also apppear:',
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


