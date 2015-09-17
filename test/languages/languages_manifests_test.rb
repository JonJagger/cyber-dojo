#!/bin/bash ../test_wrapper.sh

require_relative 'LanguagesTestBase'

class LanguagesManifestsTests < LanguagesTestBase

  test 'B892AA',
  'manifests of each languages' do
    manifests.each do |filename|
      folders = File.dirname(filename).split('/')[-2..-1]
      assert_equal 2, folders.size
      lang,test = folders
      check("#{lang}-#{test}")
    end
  end

  test 'D00EFE',
  'no two manifests have the same image_name' do
    so_far = []
    manifests.each do |filename|
      manifest = JSON.parse(IO.read(filename))
      image_name = manifest['image_name']
      refute so_far.include?(image_name), image_name
      so_far << image_name
    end
  end

  test '16735B',
  'no two manifests have the same display_name' do
    so_far = []
    manifests.each do |filename|
      manifest = JSON.parse(IO.read(filename))
      display_name = manifest['display_name']
      refute so_far.include?(display_name), display_name
      so_far << display_name
    end
  end

  def manifests
    Dir.glob("#{root_path}languages/*/*/manifest.json")
  end

  def check(language_name)
    @language = language_name
    assert manifest_file_exists?
    assert required_keys_exist?
    refute unknown_keys_exist?
    refute duplicate_visible_filenames?
    assert progress_regexs_valid?
    assert display_name_valid?
    refute filename_extension_starts_with_dot?
    assert cyberdojo_sh_exists?
    assert cyberdojo_sh_has_execute_permission?
    assert all_visible_files_exist?
    assert highlight_filenames_are_subset_of_visible_filenames?
    assert colour_method_for_unit_test_framework_output_exists?
    refute any_files_owner_is_root?
    refute any_files_group_is_root?
    refute any_file_is_unreadable?
    assert dockerfile_exists?
    assert build_docker_container_exists?
    assert build_docker_container_starts_with_cyberdojo?
    assert created_kata_manifests_language_entry_round_trips?
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

  def created_kata_manifests_language_entry_round_trips?
    language = languages[@language]
    exercise = exercises['Print_Diamond']
    kata = katas.create_kata(language, exercise)
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
    round_tripped = languages[lang]
    if !File.directory? round_tripped.path
      message = 
        alert +
        " kata #{kata.id}'s 'language' entry is #{lang}" +
        " which does not round-trip back to its own languages/sub/folder"
        puts message
        return false
    end
    print '.'
    if lang != 'Bash-shunit2' && lang.each_char.any?{|ch| "0123456789".include?(ch)}
      message =
        alert +
        " #{kata.id}'s 'language' entry is #{lang}" +
        " which contains digits and looks like it contains a version number"
        puts message
        return false        
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
    if visible_filenames.select{ |filename| filename == "cyber-dojo.sh" } == [ ]
      message =
        alert +
        "  #{manifest_filename} must contain ['cyber-dojo.sh'] in \n" +
        "  'visible_filenames'"
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
      OutputColour::of(unit_test_framework, "xx")
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
    (visible_filenames + ['manifest.json']).each do |filename|
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
    (visible_filenames + ['manifest.json']).each do |filename|
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
    (visible_filenames + ['manifest.json']).each do |filename|
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

  def dockerfile_exists?
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

  def display_name
    manifest_property
  end
  
  def visible_filenames
    manifest_property || [ ]
  end

  def progress_regexs
    manifest_property || [ ]
  end

  def highlight_filenames
    manifest_property || [ ]
  end

  def unit_test_framework
    manifest_property || [ ]
  end
  
  def manifest_property
    property_name = (caller[0] =~ /`([^']*)'/ and $1)
    manifest[property_name]
  end

  def manifest
    JSON.parse(IO.read(manifest_filename))
  end

  def manifest_filename
    language_dir + '/' + 'manifest.json'
  end

  def language_dir
    root_path + '/languages/' + language
  end
  
  def language
    @language.split('-').join('/')
  end

  def root_path
    File.expand_path('../..', File.dirname(__FILE__)) + '/'
  end

  def alert
    "\n>>>>>>>#{language}<<<<<<<\n"
  end

end
