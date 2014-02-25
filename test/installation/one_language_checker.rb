cyberdojo_root = File.absolute_path(File.dirname(__FILE__) + '/../../')
# needed because app/models/Disk requires app/models/DiskDir
$LOAD_PATH.unshift(cyberdojo_root + '/lib')

require 'JSON'
require "#{cyberdojo_root}/app/models/Avatar"
require "#{cyberdojo_root}/app/models/Dojo"
require "#{cyberdojo_root}/app/models/Kata"
require "#{cyberdojo_root}/app/models/Language"
require "#{cyberdojo_root}/app/models/Sandbox"
require "#{cyberdojo_root}/app/lib/OutputParser"
require "#{cyberdojo_root}/lib/Disk"
require "#{cyberdojo_root}/lib/Uuid"

class OneLanguageChecker

  def initialize(root_path,option)
    @root_path = root_path
    @verbose = (option == "noisy")
    @max_duration = 60
  end

  def check(
        language,
        installed_and_working = [ ],
        not_installed = [ ],
        installed_but_not_working = [ ]
    )
    @language = language
    @language_dir = @root_path + '/languages/' + language + "/"

    print "  #{language} " + ('.' * (35-language.to_s.length))

    @manifest_filename = @language_dir + 'manifest.json'
    return false if !manifest_file_exists?
    @manifest = JSON.parse(IO.read(@manifest_filename))

    return false if !required_keys_exist?
    return false if unknown_keys_exist?
    return false if duplicate_visible_filenames?
    return false if duplicate_support_filenames?
    return false if !cyberdojo_sh_exists?
    return false if !cyberdojo_sh_has_execute_permission?
    return false if !all_visible_files_exist?
    return false if !all_support_files_exist?
    return false if !parse_method_for_unit_test_framework_output_exists?
    return false if !filename_42_exists?

    t1 = Time.now
    rag = red_amber_green
    t2 = Time.now
    print " #{rag.inspect} "
    took = ((t2 - t1) / 3).round(2)
    if rag == ['red','amber','green']
      installed_and_working << language
      print "installed and working"
    elsif rag == ['amber', 'amber', 'amber']
      not_installed << language
      print " not installed"
    else
      installed_but_not_working << language
      print "installed but not working"
    end
    print " (~ #{took} seconds)\n"
    took
  end

private

  def manifest_file_exists?
    if !File.exists? @manifest_filename
      message =
        alert +
        "#{@manifest_filename} does not exist"
      puts message
      return false
    end
    print "."
    true
  end

  def required_keys_exist?
    required_keys = [ 'visible_filenames', 'unit_test_framework' ]
    required_keys.each do |key|
      if !@manifest.keys.include? key
        message =
          alert +
          "#{@manifest_filename} must contain key '#{key}'"
        puts message
        return false
      end
    end
    print "."
    true
  end

  def unknown_keys_exist?
    known = [ 'visible_filenames',
              'support_filenames',
              'unit_test_framework',
              'tab_size'
            ]
    @manifest.keys.each do |key|
      if !known.include? key
        message =
          alert +
          "#{@manifest_filename} contains unknown key '#{key}'"
        puts message
        return true
      end
    end
    print "."
    false
  end

  def duplicate_visible_filenames?
    visible_filenames.each do |filename|
      if visible_filenames.count(filename) > 1
        message =
          alert +
          "  #{@manifest_filename}'s 'visible_filenames' contains #{filename} more than once"
        puts message
        return true
      end
    end
    print "."
    false
  end

  def duplicate_support_filenames?
    support_filenames.each do |filename|
      if support_filenames.count(filename) > 1
        message =
          alert +
          "  #{@manifest_filename}'s 'support_filenames' contains #{filename} more than once"
        puts message
        return true
      end
    end
    print "."
    false
  end

  def all_visible_files_exist?
    all_files_exist?(:visible_filenames)
  end

  def all_support_files_exist?
    all_files_exist?(:support_filenames)
  end

  def all_files_exist?(symbol)
    (@manifest[symbol] || [ ]).each do |filename|
      if !File.exists?(@language_dir + filename)
        message =
          alert +
          "  #{@manifest_filename} contains a '#{symbol}' entry [#{filename}]\n" +
          "  but the #{@language_dir}/ dir does not contain a file called #{filename}"
        puts message
        return false
      end
    end
    print "."
    true
  end

  def cyberdojo_sh_exists?
    filenames = visible_filenames + support_filenames
    if filenames.select{ |filename| filename == "cyber-dojo.sh" } == [ ]
      message =
        alert +
        "  #{@manifest_filename} must contain ['cyber-dojo.sh'] in \n" +
        "  'visible_filenames' or 'support_filenames'"
      puts message
      return false
    end
    print "."
    true
  end

  def cyberdojo_sh_has_execute_permission?
    if !File.stat(@language_dir + 'cyber-dojo.sh').executable?
      message =
        alert +
          " 'cyber-dojo.sh does not have execute permission"
        puts message
        return false
    end
    print "."
    true
  end

  def parse_method_for_unit_test_framework_output_exists?
    has_parse_method = true
    begin
      OutputParser::parse(unit_test_framework, "xx")
    rescue
      has_parse_method = false
    end
    if !has_parse_method
      message =
        alert +
          "app/lib/CodeOutputParser.rb does not contain a " +
          "parse_#{unit_test_framework}(output) method"
      puts message
      return false
    end
    print "."
    true
  end

  def filename_42_exists?
    filename_42 != ""
  end

  def filename_42
    filenames = visible_filenames.select { |visible_filename|
      IO.read(@language_dir + visible_filename).include? '42'
    }
    if filenames == [ ]
      message = alert + " no 42-file"
      puts message
      return ""
    end
    if filenames.length > 1
      message = alert + " multiple 42-files " + filenames.inspect
      puts message
      return ""
    end
    print "."
    filenames[0]
  end

  def red_amber_green
    filename = filename_42
      red = language_test(filename, 'red', '42')
    amber = language_test(filename, 'amber', '4typo2')
    green = language_test(filename, 'green', '54')
    [ red, amber, green ]
  end

  def language_test(filename, expected_colour, replacement)
    kata = make_kata(@language, 'Yahtzee')
    avatar = kata.start_avatar
    visible_files = avatar.visible_files
    test_code = visible_files[filename]
    visible_files[filename] = test_code.sub('42', replacement)

    if @verbose
      puts "\n\n<test_code id='#{kata.id}' avatar='#{avatar.name}' colour='#{expected_colour}'>"
      puts visible_files[filename]
      puts "</test_code>"
    end

    delta = {
      :changed => [filename],
      :unchanged => visible_files.keys - [filename],
      :deleted => [ ],
      :new => [ ]
    }
    output = run_test(delta, avatar, visible_files, @max_duration)
    colour = avatar.traffic_lights.last['colour']

    if @verbose
      puts "<output>"
      puts output
      puts "</output>\n\n"
    end

    colour
  end

private

  def visible_filenames
    @manifest['visible_filenames'] || [ ]
  end

  def support_filenames
    @manifest['support_filenames'] || [ ]
  end

  def unit_test_framework
    @manifest['unit_test_framework'] || [ ]
  end

  def alert
    "\n>>>>>>>#{@language}<<<<<<<\n"
  end

private

  def dojo
    Thread.current[:disk] ||= Disk.new
    Dojo.new(@root_path)
  end

  def make_kata(language_name, exercise_name)
    language = dojo.language(language_name)
    manifest = {
      :created => make_time(Time.now),
      :id => Uuid.new.to_s,
      :language => language.name,
      :exercise => exercise_name,
      :visible_files => language.visible_files,
      :unit_test_framework => language.unit_test_framework,
      :tab_size => language.tab_size
    }
    manifest[:visible_files]['output'] = ''
    manifest[:visible_files]['instructions'] = 'practice'
    dojo.create_kata(manifest)
  end

  def make_time(at)
    [at.year, at.month, at.day, at.hour, at.min, at.sec]
  end

  def run_test(delta, avatar, visible_files, timeout)
    output = avatar.sandbox.test(delta, visible_files, timeout)
    language = avatar.kata.language
    traffic_light = OutputParser::parse(language.unit_test_framework, output)
    avatar.save_run_tests(visible_files, traffic_light)
    output
  end

end
