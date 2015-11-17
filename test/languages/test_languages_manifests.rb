#!/bin/bash ../test_wrapper.sh

require_relative './languages_test_base'

class LanguagesManifestsTests < LanguagesTestBase

  test 'F6B9D6',
  'no known flaws in Dockerfile of base language/' do
    Dir.glob("#{root_path}languages/*/").sort.each do |dir|
      @language = dir
      assert dockerfile_exists_and_is_well_formed?(dir + 'Dockerfile')
      assert build_docker_container_exists_and_is_well_formed?(dir + build_docker_container)
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'B892AA',
  'no known flaws in Dockerfile and manifests of each language/test/' do
    manifests.each do |filename|
      folders = File.dirname(filename).split('/')[-2..-1]
      assert_equal 2, folders.size
      lang, test = folders
      check_dockerfile_and_manifest("#{lang}-#{test}")
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'D00EFE',
  'no two language manifests have the same image_name' do
    so_far = []
    manifests.each do |filename|
      manifest = JSON.parse(IO.read(filename))
      image_name = manifest['image_name']
      refute so_far.include?(image_name), image_name
      so_far << image_name
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '16735B',
  'no two language manifests have the same display_name' do
    so_far = []
    manifests.each do |filename|
      manifest = JSON.parse(IO.read(filename))
      display_name = manifest['display_name']
      refute so_far.include?(display_name), display_name
      so_far << display_name
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def check_dockerfile_and_manifest(language_name)
    @language = language_name

    assert dockerfile_exists_and_is_well_formed?
    assert build_docker_container_exists_and_is_well_formed?

    assert manifest_file_exists?
    assert required_keys_exist?
    refute unknown_keys_exist?
    assert all_visible_files_exist?
    refute duplicate_visible_filenames?
    assert highlight_filenames_are_subset_of_visible_filenames?
    assert progress_regexs_valid?
    assert display_name_valid?
    assert image_name_valid?
    refute filename_extension_starts_with_dot?
    assert cyberdojo_sh_exists?
    assert cyberdojo_sh_has_execute_permission?
    assert colour_method_for_unit_test_framework_output_exists?
    refute any_files_owner_is_root?
    refute any_files_group_is_root?
    refute any_file_is_unreadable?
    assert created_kata_manifests_language_entry_round_trips?
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def manifest_file_exists?
    unless File.exists? manifest_filename
      return false_puts_alert "#{manifest_filename} does not exist"
    end
    true_dot
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def required_keys_exist?
    required_keys = %w( display_name image_name unit_test_framework visible_filenames )
    required_keys.each do |key|
      unless manifest.keys.include? key
        return false_puts_alert "#{manifest_filename} must contain key '#{key}'"
      end
    end
    true_dot
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def unknown_keys_exist?
    known_keys = %w( display_name
                     filename_extension
                     highlight_filenames
                     image_name
                     progress_regexs
                     tab_size
                     unit_test_framework
                     visible_filenames
                   )
    manifest.keys.each do |key|
      unless known_keys.include? key
        return true_puts_alert "#{manifest_filename} contains unknown key '#{key}'"
      end
    end
    false_dot
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def created_kata_manifests_language_entry_round_trips?
    language = languages[display_name]
    assert !language.nil?, '!language.nil?'
    exercise = exercises['Print_Diamond']
    assert !exercise.nil?, '!exercise.nil?'
    kata = katas.create_kata(language, exercise)
    manifest = disk[kata.path].read_json('manifest.json')
    lang = manifest['language']
    if lang.count('-') != 1
      message =
        "#{kata.id}'s manifest 'language' entry is #{lang}" +
        ' which does not contain a - '
      return false_puts_alert message
    end
    print '.'
    round_tripped = languages[lang]
    unless File.directory? round_tripped.path
      message =
        "kata #{kata.id}'s manifest 'language' entry is #{lang}" +
        ' which does not round-trip back to its own languages/sub/folder.' +
        ' Please check app/models/Languages.rb:new_name()'
      return false_puts_alert message
    end
    print '.'
    if lang != 'Bash-shunit2' && lang.each_char.any? { |ch| '0123456789'.include?(ch) }
      message = "#{kata.id}'s manifest 'language' entry is #{lang}" +
                ' which contains digits and looks like it contains a version number'
      return false_puts_alert message
    end
    true_dot
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def duplicate_visible_filenames?
    visible_filenames.each do |filename|
      if visible_filenames.count(filename) > 1
        message = "#{manifest_filename}'s 'visible_filenames' contains" +
                  " #{filename} more than once"
        return false_puts_alert message
      end
    end
    false_dot
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def progress_regexs_valid?
    if progress_regexs.class.name != 'Array'
      message = "#{manifest_filename}'s progress_regexs entry is not an array"
      return false_puts_alert message
    end
    if progress_regexs.length != 0 && progress_regexs.length != 2
      message = "#{manifest_filename}'s 'progress_regexs' entry does not contain 2 entries"
      return false_puts_alert message
    end
    progress_regexs.each do |s|
      begin
        Regexp.new(s)
      rescue
        return false_puts_alert "#{manifest_filename} cannot create a Regexp from #{s}"
      end
    end
    true_dot
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def display_name_valid?
    parts = display_name.split(',').select { |part| part.strip != '' }
    if parts.count != 2
      message = "#{manifest_filename}'s 'display_name':'#{display_name}'" +
                " is not in 'language,test' format"
      return false_puts_alert message
    end
    true_dot
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def image_name_valid?
    parts = image_name.split('_')
    if parts.size < 2
      message = "#{manifest_filename}'s 'image_name':'#{image_name}'" +
                " is not in 'language_test' format"
      return false_puts_alert message
    end
    language_name = parts[0]
    test_name = parts[1..-1].join('_')
    if language_name.count("0-9") > 0
      message = "#{manifest_filename}'s 'image_name':'#{image_name}'" +
                " contains digits in the language name '#{language_name}"
      return false_puts_alert message
    end
    if test_name.count(".0-9") > 0
      unless [language_name,test_name] == ['bash','shunit2']
        message = "#{manifest_filename}'s 'image_name':'#{image_name}'" +
                  " contains digits in the test name '#{test_name}"
        return false_puts_alert message
      end
    end
    true_dot
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def filename_extension_starts_with_dot?
    if manifest['filename_extension'][0] != '.'
      message = "#{manifest_filename}'s 'filename_extension' does not start with a ."
      return true_puts_alert message
    end
    false_dot
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def all_visible_files_exist?
    all_files_exist?(:visible_filenames)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def all_files_exist?(symbol)
    (manifest[symbol] || []).each do |filename|
      unless File.exists?(language_dir + '/' + filename)
        message =
          "#{manifest_filename} contains a '#{symbol}' entry [#{filename}]\n" +
          " but the #{language_dir}/ dir does not contain a file called #{filename}"
        return false_puts_alert message
      end
    end
    true_dot
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def highlight_filenames_are_subset_of_visible_filenames?
    highlight_filenames.each do |filename|
      if filename != 'instructions' &&
           filename != 'output' &&
           !visible_filenames.include?(filename)
        message =
          "#{manifest_filename} contains a 'highlight_filenames' entry ['#{filename}'] " +
          " but visible_filenames does not include '#{filename}'"
        return false_puts_alert message
      end
    end
    true_dot
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def cyberdojo_sh_exists?
    if visible_filenames.select { |filename| filename == 'cyber-dojo.sh' } == []
      message = "#{manifest_filename} must contain ['cyber-dojo.sh'] in 'visible_filenames'"
      return false_puts_alert message
    end
    true_dot
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def cyberdojo_sh_has_execute_permission?
    unless File.stat(language_dir + '/' + 'cyber-dojo.sh').executable?
      return false_puts_alert 'cyber-dojo.sh does not have execute permission'
    end
    true_dot
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def colour_method_for_unit_test_framework_output_exists?
    has_parse_method = true
    begin
      OutputColour.of(unit_test_framework, 'xx')
    rescue
      has_parse_method = false
    end
    unless has_parse_method
      message = "app/lib/OutputColour.rb does not contain a " +
                "parse_#{unit_test_framework}(output) method"
      return false_puts_alert message
    end
    true_dot
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def any_files_owner_is_root?
    (visible_filenames + ['manifest.json']).each do |filename|
      uid = File.stat(language_dir + '/' + filename).uid
      owner = Etc.getpwuid(uid).name
      if owner == 'root'
        return true_puts_alert "owner of #{language_dir}/#{filename} is root"
      end
    end
    false_dot
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def any_files_group_is_root?
    (visible_filenames + ['manifest.json']).each do |filename|
      gid = File.stat(language_dir + '/' + filename).gid
      owner = Etc.getgrgid(gid).name
      if owner == 'root'
        return true_puts_alert "owner of #{language_dir}/#{filename} is root"
      end
    end
    false_dot
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def any_file_is_unreadable?
    (visible_filenames + ['manifest.json']).each do |filename|
      unless File.stat(language_dir + '/' + filename).world_readable?
        return true_puts_alert "#{language_dir}/#{filename} is not world-readable"
      end
    end
    false_dot
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def dockerfile_exists_and_is_well_formed?(dockerfile = language_dir + '/' + 'Dockerfile')
    unless File.exists?(dockerfile)
      message = "#{language_dir}/ dir has no Dockerfile"
      return false_puts_alert(message)
    end
    content = IO.read(dockerfile)
    lines = content.strip.split("\n")
    help = 'https://docs.docker.com/articles/dockerfile_best-practices/'
    if lines.any? { |line| line.start_with?('RUN apt-get upgrade') }
      message =
        "#{dockerfile} don't use\n" +
        "RUN apt-get upGRADE\n" +
        "See #{help}"
      return false_puts_alert(message)
    end
    if lines.any? { |line| line.strip == 'RUN apt-get update' }
      message =
        "#{dockerfile} don't use single line\n" +
        "RUN apt-get update\n" +
        "See #{help}"
      return false_puts_alert(message)
    end
    if lines.any? { |line| line.start_with?('RUN apt-get install') }
      message =
        "#{dockerfile} don't use\n" +
        "RUN apt-get install...\n" +
        "use\n" +
        "RUN apt-get update && apt-get install --yes ...'\n" +
        "See #{help}"
      return false_puts_alert(message)
    end
    true_dot
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def build_docker_container_exists_and_is_well_formed?(filename = "#{language_dir}/#{build_docker_container}")
    unless File.exists?(filename)
      message = "#{language_dir}/ dir has no #{build_docker_container}"
      return false_puts_alert(message)
    end
    content = IO.read(filename)
    unless /docker build -t cyberdojofoundation/.match(content)
      message = "#{filename} does not contain 'docker build -t cyberdojofoundation/..."
      return false_puts_alert message
    end
    true_dot
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private

  def build_docker_container
    'build-docker-container.sh'
  end

  def manifests
    Dir.glob("#{root_path}languages/*/*/manifest.json").sort
  end

  def display_name
    manifest_property
  end

  def image_name
    manifest_property.split('/')[1]
  end

  def visible_filenames
    manifest_property
  end

  def unit_test_framework
    manifest_property
  end

  def progress_regexs
    manifest_property || []
  end

  def highlight_filenames
    manifest_property || []
  end

  def manifest_property
    property_name = /`(?<name>[^']*)/ =~ caller[0] && name
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

  def false_puts_alert(message)
    puts_alert message
    false
  end

  def true_puts_alert(message)
    puts_alert message
    true
  end

  def puts_alert(message)
    puts alert + '  ' + message
  end

  def alert
    "\n>>>>>>> #{language} <<<<<<<\n"
  end

  def false_dot
    print '.'
    false
  end

  def true_dot
    print '.'
    true
  end

end
