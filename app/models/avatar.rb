
class Avatar

  def self.names
    %w( alligators badgers bats bears beavers 
        buffalos camels deer elephants frogs
        giraffes gophers gorillas hippos kangaroos
        koalas lemurs lions mooses pandas
        raccoons snakes squirrels wolves zebras )
  end
  
  def initialize(dojo, name, filesets) 
    @dojo, @name = dojo, name
    if filesets
    	@filesets = filesets
    	make_dir(folder)
      File.open(folder + '/manifest.rb', 'w') do |fd| 
    	  fd.write(filesets.inspect) 
  	  end
    else
    	@filesets = eval IO.read(folder + '/manifest.rb')   	 
    end
  end

  def name
    @name
  end

  def kata
  	Kata.new(@filesets)
  end
  
  def increments
	  result = []
    io_lock(increments_filename) do 
   	  result = IO.read(increments_filename) 
    end
    eval result
  end

  def read_most_recent(kata, manifest)
    # load starting manifest
    my_increments = []
    io_lock(@dojo.folder) do 
      my_increments = locked_read_most_recent(kata, manifest)
    end
    my_increments
  end

  def run_tests(kata, manifest)
    output = ''
    io_lock(folder) do 
      output = TestRunner.avatar_run_tests(self, kata, manifest)
      manifest[:output] = output
      test_info = RunTestsOutputParser.parse(self, kata, output)
      save(manifest, test_info)
    end
    output
  end

  def folder
    @dojo.folder + '/' + name
  end

private
  
  def increments_filename
    folder + '/' + 'increments_manifest.rb'
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
    	# load manifest with initial fileset
      manifest[:visible_files] = kata.visible
      opening_file = kata.visible.include?('instructions') ? 'instructions' : 'cyberdojo.sh'
      	manifest[:current_filename] = opening_file
      manifest[:output] = welcome_text
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
      end
      my_increments
    end
  end

  def welcome_text
    [ "<------ THIS TRIANGLE IS THE 'PLAY' BUTTON.",
      '',
      'The radio-buttons on the left provide access to all files.',
      'At the sound of the bell each keyboard driver must move to another',
      'computer and take up a non-driver role.',
      '',
      "Clicking the 'play' button runs the tests on the CyberDojo server and",
      'displays the outcome here (it executes the cyberdojo.sh script file).'
    ].join("\n")
  end

  def make_dir(dir)
  	Dir.mkdir(dir) if !File.exists? dir
	end

end


