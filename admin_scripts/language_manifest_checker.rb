CYBER_DOJO_ROOT = File.absolute_path(File.dirname(__FILE__) + '/../')
require 'json'
require 'etc'
require CYBER_DOJO_ROOT + "/app/lib/OutputParser"

class LanguageManifestChecker

  def initialize(root_path)
    @root_path = root_path
    @root_path += '/' if @root_path[-1] != '/'
  end

  def check?(language)
    @language = language
    @language_dir = @root_path + '/languages/' + language

    print "  #{language} " + ('.' * (35-language.to_s.length))

    @manifest_filename = @language_dir + '/' + 'manifest.json'
    return false if !manifest_file_exists?
    raw = IO.read(@manifest_filename)
    @manifest = JSON.parse(raw)

    return false if !required_keys_exist?
    return false if unknown_keys_exist?
    return false if duplicate_visible_filenames?
    return false if duplicate_support_filenames?
    return false if filename_extension_starts_with_dot?
    return false if !cyberdojo_sh_exists?
    return false if !cyberdojo_sh_has_execute_permission?
    return false if !all_visible_files_exist?
    return false if !all_support_files_exist?
    return false if !highlight_filenames_are_subset_of_visible_filenames?
    return false if !parse_method_for_unit_test_framework_output_exists?
    return false if any_files_owner_is_root?
    return false if any_files_group_is_root?
    return false if any_file_is_unreadable?
    # Dockerfile_exists?
    # build_docker_container_exists?
    # build_docker_container_starts_with_cyberdojo
    return true
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
              'filename_extension',
              'highlight_filenames',
              'unit_test_framework',
              'tab_size',
              'display_name',
              'display_test_name',
              'image_name'
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
    print '.'
    false
  end

  def filename_extension_starts_with_dot?
    if @manifest['filename_extension'][0] != '.'
      message =
        alert +
        " #{@manifest_filename}'s 'filename_extension' does not start with a ."
        puts message
        return true
    end
    print '.'
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
      if !File.exists?(@language_dir + '/' + filename)
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

  def highlight_filenames_are_subset_of_visible_filenames?
    highlight_filenames.each do |filename|
      if filename != 'instructions' &&
           filename != 'output' &&
           !visible_filenames.include?(filename)
        message =
          alert +
          "  #{@manifest_filename} contains a 'highlight_filenames' entry ['#{filename}']\n" +
          "  but visible_filenames does not include '#{filename}'"
        puts message
        return false
      end
    end
    print "."
    return true
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
    if !File.stat(@language_dir + '/' + 'cyber-dojo.sh').executable?
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
          "app/lib/OutputParser.rb does not contain a " +
          "parse_#{unit_test_framework}(output) method"
      puts message
      return false
    end
    print "."
    true
  end

  def any_files_owner_is_root?
    (visible_filenames + support_filenames + ['manifest.json']).each do |filename|
      uid = File.stat(@language_dir + '/' + filename).uid
      owner = Etc.getpwuid(uid).name
      if owner == 'root'
        message =
          alert +
            "owner of #{@language_dir}/#{filename} is root"
        puts message
        return true
      end
    end
    print "."
    return false
  end

  def any_files_group_is_root?
    (visible_filenames + support_filenames + ['manifest.json']).each do |filename|
      gid = File.stat(@language_dir + '/' + filename).gid
      owner = Etc.getgrgid(gid).name
      if owner == 'root'
        message =
          alert +
            "owner of #{@language_dir}/#{filename} is root"
        puts message
        return true
      end
    end
    print "."
    return false
  end

  def any_file_is_unreadable?
    (visible_filenames + support_filenames + ['manifest.json']).each do |filename|
      if !File.stat(@language_dir + '/' + filename).world_readable?
        message =
          alert +
            "#{@language_dir}/#{filename} is not world-readable"
        puts message
        return true
      end
    end
    print "."
    return false
  end

private

  def visible_filenames
    @manifest['visible_filenames'] || [ ]
  end

  def support_filenames
    @manifest['support_filenames'] || [ ]
  end

  def highlight_filenames
    @manifest['highlight_filenames'] || [ ]
  end

  def unit_test_framework
    @manifest['unit_test_framework'] || [ ]
  end

  def alert
    "\n>>>>>>>#{@language}<<<<<<<\n"
  end

end
