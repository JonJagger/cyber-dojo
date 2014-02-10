require File.dirname(__FILE__) + '/../test_helper'
require 'Folders'

class OneLanguageChecker < ActionController::TestCase
  
  def initialize(options = { :verbose => true, :max_duration => 5 })
    @verbose = options[:verbose] || false
    @max_duration = options[:max_duration] || 5
    @root_dir = Rails.root.to_s + '/test/cyberdojo'    
  end
    
  def check(
        language,
        installed_and_working = [ ],
        not_installed = [ ],
        installed_but_not_working = [ ]
    )
    @language = language
    @language_dir = root_dir + '/languages/' + language + "/"
    @manifest_filename = @language_dir + 'manifest.rb'    
    check_manifest_file_exists
    @manifest = eval IO.read(@manifest_filename)
    
    check_required_keys_exist
    check_no_unknown_keys_exist
    check_no_duplicates_in_visible_filenames
    check_cyberdojo_sh_exists
    check_cyberdojo_sh_has_execute_permission
    check_named_files_exist(:visible_filenames)      
      
    rag = red_amber_green(get_filename_42)
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
  
  def check_no_duplicates_in_visible_filenames
    visible_filenames.each do |filename|
      if visible_filenames.count(filename) > 1
        message =
          alert +
          "  #{@manifest_filename}'s :visible_filenames contains #{filename} more than once"
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
    if visible_filenames.select{ |filename| filename == "cyber-dojo.sh" } == [ ]
      message =
        alert + 
        "  #{@manifest_filename} must contain ['cyber-dojo.sh'] in either\n" +
        "  :visible_filenames"
      assert false, message
    end
  end
  
  def check_cyberdojo_sh_has_execute_permission
    if !File.stat(@language_dir + 'cyber-dojo.sh').executable?
      message =
        alert +
          " 'cyber-dojo.sh does not have execute permission"
        assert false, message
    end
  end

  def visible_filenames
    @manifest[:visible_filenames] || [ ]
  end
    
  def alert
    "\n>>>>>>>#{@language}<<<<<<<\n"
  end
  
  def get_filename_42
    filenames = visible_filenames.select { |visible_filename|
      IO.read(@language_dir + visible_filename).include? '42'
    }    
    if filenames == [ ]
      message = alert + " no 42-file"
      assert false, message
    end
    if filenames.length > 1
      message = alert + " multiple 42-files " + filenames.inspect
      assert false, message
    end
    filenames[0]
  end
  
  def red_amber_green(filename)
      red = language_test(filename, '42')
    amber = language_test(filename, '4typo2')
    green = language_test(filename, '54')
    [ red, amber, green ]
  end
  
  def language_test(filename, replacement)
    kata = make_kata(@language, 'Yahtzee', Uuid.new.to_s)
    avatar = Avatar.create(kata, 'hippo')
    visible_files = avatar.visible_files
    test_code = visible_files[filename]
    assert_not_nil test_code
    visible_files[filename] = test_code.sub('42', replacement)
    
    if @verbose
      puts avatar.dir
      puts "------<test_code>------"
      puts visible_files[filename]
      puts "------</test_code>-----"
    end
    
    delta = {
      :changed => [filename],
      :unchanged => visible_files.keys - [filename],
      :deleted => [ ],
      :new => [ ]      
    }    
    output = run_test(delta, avatar, visible_files, @max_duration)
    colour = avatar.traffic_lights.last[:colour]
    
    if @verbose
      puts "-------<output>-----------"
      puts output
      puts "-------</output>----------"      
    end
    
    colour
  end    

end
