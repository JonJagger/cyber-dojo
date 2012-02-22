require File.dirname(__FILE__) + '/../test_helper'
require 'Folders'

# > ruby test/functional/installation_tests.rb

class InstallationTests < ActionController::TestCase

  include Folders

  def test_actual_installed_languages
    root_test_dir_reset        
    puts "Checking the (red,amber,green) installation testing mechanism..."
    ok = check_installed_languages_testing_mechanism
    if !ok
      puts "Installation check failed!!! not testing actual installed languages"
    else
      puts "\nOK. Now determining what's on this CyberDojo server..."
      puts "   (this will take a minute or two)"
      result = check_languages(RAILS_ROOT + '/filesets')
      installed_and_working = result[0]
      cannot_check_because_no_42_file = result[1]
      not_installed = result[2]
      installed_but_not_working = result[3]
  
      puts "\nSummary...."    
      puts 'not_installed:' + not_installed.inspect
      puts 'installed-and-working:' + installed_and_working.inspect
      puts 'cannot-check-because-no-42-file:' + cannot_check_because_no_42_file.inspect
      puts 'installed-but-not-working' + installed_but_not_working.inspect
      
      assert_equal [ ], cannot_check_because_no_42_file
      assert_equal [ ], installed_but_not_working
    end
  end

  def check_installed_languages_testing_mechanism
    result = check_languages(RAILS_ROOT + '/test/functional')
    installed_and_working = result[0]
    cannot_check_because_no_42_file = result[1]
    not_installed = result[2]
    installed_but_not_working = result[3]
    
    ['Ruby-installed-and-working'] == installed_and_working &&
    ['Ruby-no-42-file'] == cannot_check_because_no_42_file &&
    ['Ruby-not-installed'] == not_installed &&
    ['Ruby-installed-but-not-working'] == installed_but_not_working
  end
  
  def check_languages(filesets_root_dir)
    cannot_check_because_no_42_file = [ ]
    installed_and_working = [ ]
    not_installed = [ ]
    installed_but_not_working = [ ]
        
    languages_root_dir = filesets_root_dir + '/language'
    languages = folders_in(languages_root_dir).sort
    languages.each do |language|
      @language = language
      @language_dir = languages_root_dir + '/' + language
      check_manifest_file_exists
      @manifest = eval IO.read(@manifest_filename)      
      check_manifest
      filenames42 = get_filenames_42
      
      if filenames42 == [ ]
        cannot_check_because_no_42_file << language
        puts "  #{language} - cannot check because no 42 file"
      else
        rag = red_amber_green(filesets_root_dir, language, filenames42[0])
        if rag == [:red,:amber,:green]
          installed_and_working << language
          puts "  #{language} - #{rag.inspect} - installed and working"
        elsif rag == [:amber, :amber, :amber]
          not_installed << language
          puts "  #{language} - #{rag.inspect} - not installed"
        else
          installed_but_not_working << language
          puts "  #{language} - #{rag.inspect} - installed but not working"          
        end
      end
    end
    [
      installed_and_working,
      cannot_check_because_no_42_file,
      not_installed,
      installed_but_not_working
    ]
  end
  
  def check_manifest
    check_required_keys_exist
    check_no_unknown_keys_exist
    check_no_filenames_are_duplicated
    check_cyberdojo_sh_exists
    check_named_files_exist(:hidden_filenames)
    check_named_files_exist(:visible_filenames)      
  end
  
  def check_manifest_file_exists    
    @manifest_filename = @language_dir + '/manifest.rb'
    if !File.exists? @manifest_filename
      message =
        alert + 
        "#{@manifest_filename} does not exists"
      assert false, message
    end
  end
  
  def check_required_keys_exist
    required = [ :visible_filenames, :unit_test_framework ]
    required.each do |key|
      if !@manifest.keys.include? key
        message =
          alert + 
          "#{@manifest_filename} must contain key :#{key}"  
        assert false, message
      end
    end    
  end
  
  def check_no_unknown_keys_exist
    known = [ :visible_filenames, :hidden_filenames, :unit_test_framework, :tab_size]
    @manifest.keys.each do |key|
      if !known.include? key
        message =
          alert + 
          "#{@manifest_filename} contains unknown key :#{key}"
        assert false, message
      end
    end    
  end
  
  def check_no_filenames_are_duplicated
    visible_filenames = @manifest[:visible_filenames]
    hidden_filenames = @manifest[:hidden_filenames] || [ ]
    
    visible_filenames.each do |filename|
      if hidden_filenames.count(filename) > 0
        message =
          alert + 
          "  #{@manifest_filename}'s :visible_filenames contains #{filename}\n" +
          "  which is also in :hidden_filenames"
        assert false, message        
      end
    end

    visible_filenames.each do |filename|
      if visible_filenames.count(filename) > 1
        message =
          alert +
          "  #{@manifest_filename}'s :visible_filenames contains #{filename} more than once"
        assert false, message
      end
    end
    
    hidden_filenames.each do |filename|
      if hidden_filenames.count(filename) > 1
        message =
          alert +
          "  #{@manifest_filename}'s :hidden_filenames contains #{filename} more than once"
        assert false, message
      end
    end
  end

  def check_named_files_exist(symbol)
    (@manifest[symbol] || [ ]).each do |filename|
      pathed_filename = @language_dir + '/' + filename
      if !File.exists?(pathed_filename)
        message =
          alert + 
          "  #{@manifest_filename} contains a :#{symbol} entry [#{filename}]\n" +
          "  but the #{@language_dir}/ dir does not contain a file called #{filename}"
        assert false, message
      end
    end    
  end
  
  def check_cyberdojo_sh_exists
    visible_filenames = @manifest[:visible_filenames]
    hidden_filenames = @manifest[:hidden_filenames] || [ ]
    all_filenames = visible_filenames + hidden_filenames
    if all_filenames.select{|filename| filename == "cyberdojo.sh" } == [ ]
      message =
        alert + 
        "  #{@manifest_filename} must contain ['cyberdojo.sh'] in either\n" +
        "  :visible_filenames or :hidden_filenames"
      assert false, message
    end
  end
  
  def alert
    "\n>>>>>>>#{@language}<<<<<<<\n"
  end
  
  def get_filenames_42
    (@manifest[:visible_filenames] || [ ]).select do |visible_filename|
      IO.read(@language_dir + '/' + visible_filename).include? '42'
    end
  end
  
  def traffic_light_map(outcome)
    return :red if outcome == :failed
    return :amber if outcome == :error
    return :green if outcome == :passed
  end
  
  def red_amber_green( filesets_root_dir, language, filename )
    red = language_test(filesets_root_dir, language, filename, '42')
    amber = language_test(filesets_root_dir, language, filename, '4typo2')
    green = language_test(filesets_root_dir, language, filename, '54')
    [ red,amber,green ].map{|outcome| traffic_light_map(outcome)}
  end
  
  def language_test( filesets_root_dir, language, filename , rhs )
    kata = make_kata(filesets_root_dir, language)
    avatar_name = 'hippo'
    avatar = Avatar.new(kata, avatar_name)
    visible_files = avatar.visible_files
    test_code = visible_files[filename]    
    visible_files[filename] = test_code.sub('42', rhs)
    avatar.run_tests(visible_files)
    avatar.increments.last[:outcome]
  end    

  def make_kata(filesets_root_dir, language)
    params = make_params(filesets_root_dir, language)
    fileset = InitialFileSet.new(params)
    info = Kata::create_new(fileset)
    params[:id] = info[:id]
    Kata.new(params)    
  end

  def make_params(filesets_root_dir, language)
    params = {
      :katas_root_dir => KATA_ROOT_DIR,
      :filesets_root_dir => filesets_root_dir,
      :browser => 'Firefox',
      'language' => language,
      'exercise' => 'Yahtzee',
      'name' => 'Jon Jagger'
    }
  end

  def root_test_dir_reset
    system("rm -rf #{KATA_ROOT_DIR}")
    Dir.mkdir KATA_ROOT_DIR
  end
  
  KATA_ROOT_DIR = RAILS_ROOT + '/test/katas'

end
