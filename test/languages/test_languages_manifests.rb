#!/usr/bin/env ruby

require_relative 'languages_test_base'

class LanguagesManifestsTests < LanguagesTestBase

  include ExternalSetter

  def setup
    @root_path = root_path
    reset_external(:disk, Disk.new)
    reset_external(:git, Git.new)
    reset_external(:runner, HostTestRunner.new)
    reset_external(:exercises_path, root_path + 'exercises/')
    reset_external(:languages_path, root_path + 'languages/')
    reset_external(:katas_path, root_path + 'test/cyber-dojo/katas/')    
  end

  def root_path
    File.expand_path('../..', File.dirname(__FILE__)) + '/'
  end

  test 'manifests of all languages' do
    dirs = Dir.glob("#{root_path}languages/*/*/manifest.json").each do |file|
      folders = File.dirname(file).split('/')[-2..-1]
      assert_equal 2, folders.size
      lang,test = folders
      check("#{lang}-#{test}")
    end
  end

  def check(language_name)
    @language = language_name
    assert manifest_file_exists?
    assert required_keys_exist?
    assert !unknown_keys_exist?
    assert !duplicate_visible_filenames?
    assert !duplicate_support_filenames?
    assert progress_regexs_valid?
    assert display_name_valid?
    assert !filename_extension_starts_with_dot?
    assert cyberdojo_sh_exists?
    assert cyberdojo_sh_has_execute_permission?
    assert all_visible_files_exist?
    assert all_support_files_exist?
    assert highlight_filenames_are_subset_of_visible_filenames?
    assert colour_method_for_unit_test_framework_output_exists?
    assert !any_files_owner_is_root?
    assert !any_files_group_is_root?
    assert !any_file_is_unreadable?
    assert Dockerfile_exists?
    assert build_docker_container_exists?
    assert build_docker_container_starts_with_cyberdojo?
    assert created_kata_manifests_language_entry_round_trips?
    assert display_name_maps_back_to_language_name?
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def manifest_file_exists?
    if !File.exists? manifest_filename
      message =
        alert +
        "#{manifest_filename} does not exist"
      puts message
      return false
    end
    print '.'
    true
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def required_keys_exist?
    required_keys = [ 'visible_filenames', 'display_name', 'unit_test_framework' ]
    required_keys.each do |key|
      if !manifest.keys.include? key
        message =
          alert +
          "#{manifest_filename} must contain key '#{key}'"
        puts message
        return false
      end
    end
    print "."
    true
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def unknown_keys_exist?
    known = [ 'visible_filenames',
              'support_filenames',
              'progress_regexs',
              'filename_extension',
              'highlight_filenames',
              'unit_test_framework',
              'tab_size',
              'display_name',
              'image_name'
            ]
    manifest.keys.each do |key|
      if !known.include? key
        message =
          alert +
          "#{manifest_filename} contains unknown key '#{key}'"
        puts message
        return true
      end
    end
    print "."
    false
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def display_name_maps_back_to_language_name?
    languages = Languages.new
    reset_external(:disk, Disk.new)
    reset_external(:languages_path, root_path + 'languages/')
    display_name = languages[@language].display_name
    part = lambda { |n| display_name.split(',')[n].strip }
    language_name,test_name = part.(0), part.(1)
    round_trip = languages[language_name + '-' + test_name]
    if @language != round_trip.name
      message = 
        alert +
        " #{manifest_filename}'s 'display_name' entry" +
        " when used from setup page is not mapped " +
        " back to its own languages/sub/folder name" 
      puts message
      return false
    end
    print '.'
    true
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def created_kata_manifests_language_entry_round_trips?
    dojo = Dojo.new    
    language = dojo.languages[@language]
    exercise = dojo.exercises['Print_Diamond']
    kata = dojo.katas.create_kata(language, exercise)
    manifest = JSON.parse(kata.dir.read('manifest.json'))
    lang = manifest['language']
    if lang.count('-') != 1
      message = 
        alert +
        " #{kata.id}'s 'language' entry is #{lang}" +
        " which does not contain a - "
        puts message
        return false
    end
    print '.'
    round_tripped = dojo.languages[lang]
    if !File.directory? round_tripped.path
      message = 
        alert +
        " kata #{kata.id}'s 'language' entry is #{lang}" +
        " which does not round-trip back to its own languages/sub/folder"
        puts message
        return false
    end
    print '.'
    if lang.each_char.any?{|ch| "0123456789".include?(ch)}
      message =
        alert +
        " #{kata.id}'s 'language' entry is #{lang}" +
        " which contains digits and looks like it contains a version number"
        puts message
        return false
        # eg "language":"g++4.8.1-GoogleTest"
        # Now kata.language -->
        #       dojo.languages[manifest_property]
        #       which, if it worked, would mean I'd have to store
        #       version numbers for every historical version upgrade.
        #       So a kata's manifest.json file's 'language' entry
        #       needs to be the display-name
        #       How does a kata's manifest.json file's 'language' entry get set
        #       app/models/Katas.rb
        #        { :language => language.name }
        #       And app/models/Language.rb
        #         def name
        #           @language_name + '-' + @test_name
        #         end
        #       and @language_name,@test_name are passed in as the dirs.
        #       Could I use the display_name (from the manifest here)?
        #       Eg languages/g++4.8.1/assert/manifest.json
        #          { :display_name => 'C++, assert' }
        #       Perhaps do
        #       And app/models/Language.rb
        #         def name
        #           display_name.split(',').map{ |s| s.strip }.join('-')
        #         end
        #
        # Also, exercise and language don't need to be passed path in their
        # ctors - they can get it from the relevant external!
        # Katas [] does Kata.new(self,id) 
        # So perhaps Exercises and Languages should pass self instead of path.
        #
        # cache.json can be reinstated.
        #
        # dojo.languages['C++'].tests['assert'].path
        #
        # outer-loop on languages
        #   inner-loop on tests
        #       do something here, don't get languages with no tests
        #
        # Do I need to have .name at all?
        # display_name covers what appears in setup
        # and path covers access to files on disk
        
    end    
    print '.'
    true
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  def duplicate_visible_filenames?
    visible_filenames.each do |filename|
      if visible_filenames.count(filename) > 1
        message =
          alert +
          " #{manifest_filename}'s 'visible_filenames' contains" +
          " #{filename} more than once"
        puts message
        return true
      end
    end
    print '.'
    false
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def duplicate_support_filenames?
    support_filenames.each do |filename|
      if support_filenames.count(filename) > 1
        message =
          alert +
          " #{manifest_filename}'s 'support_filenames' contains" +
          " #{filename} more than once"
        puts message
        return true
      end
    end
    print '.'
    false
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def progress_regexs_valid?
    if progress_regexs.class.name != "Array"
        message =
          alert + " #{manifest_filename}'s progress_regexs entry is not an array"
        puts message
        return false
    end
    if progress_regexs.length != 0 && progress_regexs.length != 2
        message =
          alert + " #{manifest_filename}'s 'progress_regexs' entry does not contain 2 entries"
        puts message
        return false
    end
    progress_regexs.each do |s|
      begin
        Regexp.new(s)
      rescue
        message =
          alert + " #{manifest_filename} cannot create a Regexp from #{s}"
        puts message
        return false
      end
    end
    print '.'
    true
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def display_name_valid?
    if display_name.count(',') != 1
      message = 
        alert +
        " #{manifest_filename}'s 'display_name' entry is #{display_name} " +
        " which does not contain a single comma"
      puts message
      return false
    end
    print '.'
    true
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def filename_extension_starts_with_dot?
    if manifest['filename_extension'][0] != '.'
      message =
        alert +
        " #{manifest_filename}'s 'filename_extension' does not start with a ."
        puts message
        return true
    end
    print '.'
    false
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def all_visible_files_exist?
    all_files_exist?(:visible_filenames)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def all_support_files_exist?
    all_files_exist?(:support_filenames)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def all_files_exist?(symbol)
    (manifest[symbol] || [ ]).each do |filename|
      if !File.exists?(language_dir + '/' + filename)
        message =
          alert +
          "  #{manifest_filename} contains a '#{symbol}' entry [#{filename}]\n" +
          "  but the #{language_dir}/ dir does not contain a file called #{filename}"
        puts message
        return false
      end
    end
    print '.'
    true
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def highlight_filenames_are_subset_of_visible_filenames?
    highlight_filenames.each do |filename|
      if filename != 'instructions' &&
           filename != 'output' &&
           !visible_filenames.include?(filename)
        message =
          alert +
          "  #{manifest_filename} contains a 'highlight_filenames' entry ['#{filename}']\n" +
          "  but visible_filenames does not include '#{filename}'"
        puts message
        return false
      end
    end
    print '.'
    true
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def cyberdojo_sh_exists?
    filenames = visible_filenames + support_filenames
    if filenames.select{ |filename| filename == "cyber-dojo.sh" } == [ ]
      message =
        alert +
        "  #{manifest_filename} must contain ['cyber-dojo.sh'] in \n" +
        "  'visible_filenames' or 'support_filenames'"
      puts message
      return false
    end
    print '.'
    true
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def cyberdojo_sh_has_execute_permission?
    if !File.stat(language_dir + '/' + 'cyber-dojo.sh').executable?
      message =
        alert +
          " 'cyber-dojo.sh does not have execute permission"
        puts message
        return false
    end
    print '.'
    true
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def colour_method_for_unit_test_framework_output_exists?
    has_parse_method = true
    begin
      OutputParser::colour(unit_test_framework, "xx")
    rescue
      has_parse_method = false
    end
    if !has_parse_method
      message =
        alert +
          "app/lib/OutputParser.rb does not contain a " +
          "parse_#{unit_test_framework}(output) method"
      puts message
      return false
    end
    print '.'
    true
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def any_files_owner_is_root?
    # for HostTestRunner
    (visible_filenames + support_filenames + ['manifest.json']).each do |filename|
      uid = File.stat(language_dir + '/' + filename).uid
      owner = Etc.getpwuid(uid).name
      if owner == 'root'
        message =
          alert +
            "owner of #{language_dir}/#{filename} is root"
        puts message
        return true
      end
    end
    print '.'
    false
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def any_files_group_is_root?
    # for HostTestRunner
    (visible_filenames + support_filenames + ['manifest.json']).each do |filename|
      gid = File.stat(language_dir + '/' + filename).gid
      owner = Etc.getgrgid(gid).name
      if owner == 'root'
        message =
          alert +
            "owner of #{language_dir}/#{filename} is root"
        puts message
        return true
      end
    end
    print '.'
    false
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def any_file_is_unreadable?
    (visible_filenames + support_filenames + ['manifest.json']).each do |filename|
      if !File.stat(language_dir + '/' + filename).world_readable?
        message =
          alert +
            "#{language_dir}/#{filename} is not world-readable"
        puts message
        return true
      end
    end
    print '.'
    false
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def Dockerfile_exists?
    if !File.exists?(language_dir + '/' + 'Dockerfile')
      message =
        alert +
        "  #{language_dir}/ dir does not contain a file called Dockerfile"
      puts message
      return false
    end
    print '.'
    true
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def build_docker_container_exists?
    if !File.exists?(language_dir + '/' + 'build-docker-container.sh')
      message =
        alert +
        "  #{language_dir}/ dir does not contain a file called build-docker-container.sh"
      puts message
      return false
    end
    print '.'
    true
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def build_docker_container_starts_with_cyberdojo?
    filename = language_dir + '/' + 'build-docker-container.sh'
    content = IO.read(filename)
    if !/docker build -t cyberdojo/.match(content)
      message =
        alert +
        " #{filename} does not contain 'docker build -t cyberdojo/"
      puts message
      return false
    end
    print '.'
    true
  end

private

  def language
    @language.split('-').join('/')
  end

  def language_dir
    @root_path + '/languages/' + language
  end

  def manifest_filename
    language_dir + '/' + 'manifest.json'
  end

  def manifest
    JSON.parse(IO.read(manifest_filename))
  end

  def display_name
    manifest['display_name']
  end
  
  def visible_filenames
    manifest['visible_filenames'] || [ ]
  end

  def support_filenames
    manifest['support_filenames'] || [ ]
  end

  def progress_regexs
    manifest['progress_regexs'] || [ ]
  end

  def highlight_filenames
    manifest['highlight_filenames'] || [ ]
  end

  def unit_test_framework
    manifest['unit_test_framework'] || [ ]
  end

  def alert
    "\n>>>>>>>#{language}<<<<<<<\n"
  end

end
