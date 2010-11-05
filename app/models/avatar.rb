
require 'io_lock.rb'

class Avatar

  def self.names
    %w( alligators badgers bats bears beavers 
        buffalos camels cheetahs deer elephants frogs
        giraffes gophers gorillas hippos kangaroos
        koalas lemurs lions mooses pandas
        raccoons snakes squirrels wolves zebras )
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
			File.open(manifest_filename, 'w') do |fd| 
				fd.write(@filesets.inspect) 
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
    File.open(dst_folder + '/manifest.rb', 'w') do |fd| 
    	fd.write(manifest.inspect) 
    end

    now = Time.now
    test_info[:time] = [now.year, now.month, now.day, now.hour, now.min, now.sec]
    test_info[:number] = my_increments.length
    my_increments << test_info
    
    File.open(increments_filename, 'w') do |file| 
    	file.write(my_increments.inspect) 
    end
    my_increments
  end

  def locked_read_most_recent(kata, manifest)
    if !File.exists?(increments_filename) # start
    	load_manifest_from_kata(manifest, kata)     
      # Create sandbox and copy hidden files from kata fileset 
      # into sandbox ready for future run_tests
      make_dir(folder + '/sandbox')
      kata.hidden_pathnames.each do |hidden_pathname|
        system("cp '#{hidden_pathname}' '#{folder}/sandbox'") 
      end
      # Create empty increments file ready to be loaded next time
      File.open(increments_filename, 'w') do |file| 
        file.write([].inspect) 
      end
      []
    else # restart
      my_increments = increments
      if my_increments.length != 0
        current_increment_folder = folder + '/' + (my_increments.length - 1).to_s
        restart_manifest = eval IO.read(current_increment_folder + '/' + 'manifest.rb')
        manifest[:visible_files] = restart_manifest[:visible_files]
        manifest[:current_filename] = restart_manifest[:current_filename]
        manifest[:output] = restart_manifest[:output]
      else
      	load_manifest_from_kata(manifest, kata)
      end
      my_increments
    end
  end

  def load_manifest_from_kata(manifest, kata)
   	# load manifest with initial fileset
		manifest[:visible_files] = kata.visible
		opening_file = kata.visible.include?('instructions') ? 'instructions' : 'cyberdojo.sh'
		manifest[:current_filename] = opening_file
		manifest[:output] = welcome_text
  end
  
  def welcome_text
    [ "<----- Click this 'play' button (keyboard shortcut Control S) to run the",
      '       tests on the CyberDojo server (it executes the cyberdojo.sh file)',
      '       and display the outcome here.',
      '',
      '       Click the radio-buttons on the left to open files in the editor.',
    ].join("\n")
  end

  def make_dir(dir)
  	Dir.mkdir(dir) if !File.exists? dir
	end

end


