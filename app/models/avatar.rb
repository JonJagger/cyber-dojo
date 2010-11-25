
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
    
      if File.exists?(manifest_filename)
        @filesets = eval IO.read(manifest_filename)
      else
        @filesets = filesets
      end
        
      make_dir(folder)      
      file_write(manifest_filename, @filesets)
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

  def read_most_recent(kata, manifest)
    io_lock(folder) { locked_read_most_recent(kata, manifest) }
  end

  def run_tests(kata, manifest)
    io_lock(folder) do 
      output = TestRunner.avatar_run_tests(self, kata, manifest)
      manifest[:output] = output
      test_info = RunTestsOutputParser.parse(self, kata, output)
      save(manifest, test_info)
    end
  end

  def folder
    @dojo.folder + '/' + name
  end

private

  def manifest_filename
    folder + '/' + 'manifest.rb'
  end
  
  def increments_filename
    folder + '/' + 'increments_manifest.rb'
  end

  def random_unused_avatar
    Avatar.names.select { |name| !File.exists? @dojo.folder + '/' + name }.shuffle[0]
  end
    
  def save(manifest, test_info)    
    my_increments = increments
    dst_folder = folder + '/' + my_increments.length.to_s
    make_dir(dst_folder)
    file_write(dst_folder + '/manifest.rb', manifest)
    test_info[:time] = make_time(Time.now)
    test_info[:number] = my_increments.length
    my_increments << test_info
    file_write(increments_filename, my_increments)
    my_increments
  end

  def locked_read_most_recent(kata, manifest)
    most_recent = nil
    if !File.exists?(increments_filename) # start
      load_manifest_from_kata(manifest, kata)     
      # Create sandbox and copy hidden files from kata fileset 
      # into sandbox ready for future run_tests
      make_dir(folder + '/sandbox')
      kata.hidden_pathnames.each do |hidden_pathname|
        system("cp '#{hidden_pathname}' '#{folder}/sandbox'") 
      end
      # Create empty increments file ready to be loaded next time
      most_recent = []
      file_write(increments_filename, most_recent)
    else # restart
      most_recent = increments
      if most_recent.length != 0
        current_increment_folder = folder + '/' + (most_recent.length - 1).to_s
        restart_manifest = eval IO.read(current_increment_folder + '/' + 'manifest.rb')
        manifest[:visible_files] = restart_manifest[:visible_files]
        manifest[:current_filename] = restart_manifest[:current_filename]
        manifest[:output] = restart_manifest[:output]
      else
        load_manifest_from_kata(manifest, kata)
      end
    end
    most_recent
  end

  def load_manifest_from_kata(manifest, kata)
    # load manifest with initial fileset
    manifest[:visible_files] = kata.visible
    opening_file = kata.visible.include?('instructions') ? 'instructions' : 'cyberdojo.sh'
    manifest[:current_filename] = opening_file
    manifest[:output] = welcome_text
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

  def make_dir(dir)
    Dir.mkdir(dir) if !File.exists? dir
  end

end


