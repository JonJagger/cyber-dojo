require File.dirname(__FILE__) + '/../test_helper'
require 'Folders'

class OneLanguageChecker < ActionController::TestCase
  
  def initialize(verbose = false, max_duration = 5)
    @verbose = verbose
    @max_duration = max_duration
  end
    
  def check(
        root_dir,
        language,
        cannot_check_because_no_42_file = [ ],
        installed_and_working = [ ],
        not_installed = [ ],
        installed_but_not_working = [ ]
    )
    @root_dir = root_dir
    @language = language
    @language_dir = root_dir + '/languages/' + language + "/"
    @manifest_filename = @language_dir + 'manifest.rb'    
    check_manifest_file_exists
    @manifest = eval IO.read(@manifest_filename)
    
    check_required_keys_exist
    check_no_unknown_keys_exist
    check_no_duplicates_in_both_visible_and_hidden_filenames
    check_no_duplications_inside_visible_filenames
    check_no_duplications_inside_hidden_filenames
    check_cyberdojo_sh_exists
    check_named_files_exist(:hidden_filenames)
    check_named_files_exist(:visible_filenames)      
    filenames42 = get_filenames_42
      
    # TODO: if filenames42.length > 1 that is also a probable error
    if filenames42 == [ ]
      cannot_check_because_no_42_file << language
      puts "  #{language}  cannot check because no 42 file"
    else
      rag = red_amber_green(filenames42[0])
      if rag == [:red,:amber,:green]
        installed_and_working << language
        puts "  #{language} - #{rag.inspect}  installed and working"
      elsif rag == [:amber, :amber, :amber]
        not_installed << language
        puts "  #{language} - #{rag.inspect}  not installed"
      else
        installed_but_not_working << language
        puts "  #{language} - #{rag.inspect}  installed but not working"          
      end
    end
  end
    
  def check_manifest_file_exists    
    if !File.exists? @manifest_filename
      message =
        alert + 
        "#{@manifest_filename} does not exist"
      assert false, message
    end
  end
  
  def check_required_keys_exist
    required_keys = [ :visible_filenames, :unit_test_framework ]
    required_keys.each do |key|
      if !@manifest.keys.include? key
        message =
          alert + 
          "#{@manifest_filename} must contain key :#{key}"  
        assert false, message
      end
    end
  end
  
  def check_no_unknown_keys_exist
    known = [ :visible_filenames,
              :hidden_filenames,
              :support_filenames,
              :unit_test_framework,
              :tab_size
            ]
    @manifest.keys.each do |key|
      if !known.include? key
        message =
          alert + 
          "#{@manifest_filename} contains unknown key :#{key}"
        assert false, message
      end
    end    
  end
  
  def check_no_duplicates_in_both_visible_and_hidden_filenames    
    visible_filenames.each do |filename|
      if hidden_filenames.count(filename) > 0
        message =
          alert + 
          "  #{@manifest_filename}'s :visible_filenames contains #{filename}\n" +
          "  which is also in :hidden_filenames"
        assert false, message        
      end
    end    
  end
  
  def check_no_duplications_inside_visible_filenames
    visible_filenames.each do |filename|
      if visible_filenames.count(filename) > 1
        message =
          alert +
          "  #{@manifest_filename}'s :visible_filenames contains #{filename} more than once"
        assert false, message
      end
    end
  end
  
  def check_no_duplications_inside_hidden_filenames
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
      if !File.exists?(@language_dir + filename)
        message =
          alert + 
          "  #{@manifest_filename} contains a :#{symbol} entry [#{filename}]\n" +
          "  but the #{@language_dir}/ dir does not contain a file called #{filename}"
        assert false, message
      end
    end    
  end
  
  def check_cyberdojo_sh_exists
    all_filenames = visible_filenames + hidden_filenames
    if all_filenames.select{ |filename| filename == "cyber-dojo.sh" } == [ ]
      message =
        alert + 
        "  #{@manifest_filename} must contain ['cyber-dojo.sh'] in either\n" +
        "  :visible_filenames or :hidden_filenames"
      assert false, message
    end
  end
  
  def visible_filenames
    @manifest[:visible_filenames] || [ ]
  end
  
  def hidden_filenames
    @manifest[:hidden_filenames] || [ ]     
  end
    
  def alert
    "\n>>>>>>>#{@language}<<<<<<<\n"
  end
  
  def get_filenames_42
    visible_filenames.select do |visible_filename|
      IO.read(@language_dir + visible_filename).include? '42'
    end
  end
  
  def red_amber_green(filename)
      red = language_test(filename, '42')
    amber = language_test(filename, '4typo2')
    green = language_test(filename, '54')
    [ red, amber, green ]
  end
  
  def language_test(filename, rhs)
    kata = make_kata(@language, 'Yahtzee', Uuid.new.to_s)
    avatar = Avatar.new(kata, 'hippo')
    visible_files = avatar.visible_files
    test_code = visible_files[filename]
    assert_not_nil test_code
    visible_files[filename] = test_code.sub('42', rhs)
    
    if @verbose
      puts "------<test_code>------"
      puts visible_files[filename]
      puts "------</test_code>-----"
    end
    
    run_tests(avatar, visible_files, @max_duration)
    colour = avatar.increments.last[:colour]
    
    if @verbose
      puts "-------<output>-----------"
      puts avatar.visible_files['output']
      puts "-------</output>----------"      
    end
    
    colour
  end    

end
