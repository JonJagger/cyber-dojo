
require 'file_write.rb'
require 'io_lock.rb'
require 'make_time.rb'

class Avatar

  def self.names
    %w( alligators bats bears buffalos camels cheetahs 
        deer elephants frogs giraffes gophers gorillas 
        hippos kangaroos koalas lemurs lions mooses 
        pandas raccoons snakes squirrels wolves zebras )
  end
  
  def initialize(dojo, name, filesets = nil) 
    @dojo = dojo
    io_lock(@dojo.folder) do
      @name = name || random_unused_avatar
      
      filesets ||= {}
      filesets['kata'] ||= FileSet.random('kata')
      filesets['language'] ||= FileSet.random('language')
    
      if File.exists?(filesets_filename)
        @filesets = eval IO.read(filesets_filename)
      else
        @filesets = filesets
        Dir.mkdir(folder)
        file_write(filesets_filename, @filesets)
        file_write(increments_filename, [])
        # Create sandbox
        Dir.mkdir(sandbox)
        # Copy hidden files from kata fileset 
        # into sandbox ready for future run_tests        
        kata = Kata.new(@filesets)
        kata.hidden_pathnames.each do |hidden_pathname|
          system("cp '#{hidden_pathname}' '#{sandbox}'") 
        end
        # Copy visible files into sandbox (needed for diff 0 1)
        kata.visible_files.each do |filename,file|
          TestRunner.save_file(sandbox, filename, file)
        end

        kata.manifest[:output] = welcome_text
        kata.manifest[:current_filename] = 'instructions'
        kata.manifest.delete(:hidden_filenames)
        kata.manifest.delete(:hidden_pathnames)
        file_write(manifest_filename, kata.manifest)
        
        cmd  = "cd '#{folder}';"
        cmd += "git init;"
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
    Kata.new(@filesets)
  end
   
  def increments
    io_lock(increments_filename) { eval IO.read(increments_filename) }
  end

  def read_most_recent(manifest)
    io_lock(folder) do
      restart_manifest = eval IO.read(manifest_filename)
      manifest[:visible_files] = restart_manifest[:visible_files]
      manifest[:current_filename] = restart_manifest[:current_filename]
      manifest[:output] = restart_manifest[:output]
      increments
    end
  end

  def run_tests(kata, manifest)
    incs = [] 
    io_lock(folder) do 
      
      output = TestRunner.avatar_run_tests(self, kata, manifest)
      test_info = RunTestsOutputParser.parse(self, kata, output)
      
      incs = increments     
      incs << test_info
      test_info[:time] = make_time(Time.now)
      test_info[:number] = incs.length
      file_write(increments_filename, incs)

      manifest[:output] = output      
      file_write(manifest_filename, manifest)
      
      tag = incs.length
      git_commit_tag(manifest[:visible_files], tag)
    end
    incs
  end

  def folder
    @dojo.folder + '/' + name
  end
  
  def sandbox
    folder + '/' + 'sandbox'
  end

private

  def filesets_filename
    folder + '/' + 'filesets.rb'
  end

  def manifest_filename
    folder + '/' + 'manifest.rb'
  end
  
  def increments_filename
    # The number of entries in this file equals the number
    # of git commits/tags, including zero.
    folder + '/' + 'increments.rb'
  end

  def random_unused_avatar
    Avatar.names.select { |name| !File.exists? @dojo.folder + '/' + name }.shuffle[0]
  end

  def welcome_text
    [ "<----- Click this 'play' button to run the tests on the CyberDojo server",
      '       (execute cyberdojo.sh). The test outcome is displayed here.',
      '',
      '       Click the radio-buttons on the left to open files in the editor.',
      '',
      '       Keyboard shortcuts',
      '         Control-S == run tests',
      '         Control-N == open next file)'
    ].join("\n")
  end

  def git_commit_tag(visible_files, n)
    # I add visible files to the git repository
    # but never the hidden files.
    cmd  = "cd '#{folder}';"
    visible_files.each do |filename,|
      cmd += "git add '#{sandbox}/#{filename}';"
    end
    cmd += "git commit -a -m '#{n}';"
    cmd += "git tag -m '#{n}' #{n} HEAD;"
    system(cmd)    
  end
  
end


