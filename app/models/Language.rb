# See comments at end of file

class Language
  include ExternalParentChain

  def initialize(languages,name,test_name)
    @parent,@name,@test_name = languages,name,test_name
  end

  def path
    @parent.path + @name + '/' + @test_name + '/'
  end

  def name    
    display_name.split(',').map{ |s| s.strip }.join('-')
  end

  def display_name
    manifest_property
  end

  def exists?
    dir.exists?(manifest_filename)
  end

  def runnable?
    runner.runnable?(self)
  end

  def image_name
    manifest_property
  end

  def unit_test_framework
    manifest_property
  end

  def display_test_name
    manifest_property || unit_test_framework
  end

  def filename_extension
    manifest_property || ''
  end

  def visible_filenames
    manifest_property || [ ]
  end

  def visible_files
    Hash[visible_filenames.collect{ |filename|
      [ filename, read(filename) ]
    }]
  end

  def support_filenames
    manifest_property || [ ]
  end

  def highlight_filenames
    manifest_property || [ ]
  end

  def progress_regexs
    manifest_property || [ ]
  end

  def tab_size
    manifest_property || 4
  end

  def tab
    " " * tab_size
  end

  def lowlight_filenames
    if !highlight_filenames.empty?
      return visible_filenames - highlight_filenames
    else
      return ['cyber-dojo.sh', 'makefile', 'Makefile', 'unity.license.txt']
    end
  end

  def colour(output)
    OutputColour.of(unit_test_framework, output)
  end

  def after_test(dir, visible_files)
    if name.include?('Approval')
      add_created_txt_files(dir, visible_files)
      remove_deleted_txt_files(dir, visible_files)
    end
  end

private

  include ManifestProperty

  def manifest
    begin
      @manifest ||= JSON.parse(read(manifest_filename))
    rescue Exception => e
      message =  "JSON.parse(#{manifest_filename}) exception" + "\n" +
        "language: " + path + "\n" +
        " message: " + e.message
      raise message
    end
  end

  def manifest_filename
    'manifest.json'
  end

  def read(filename)
    dir.read(filename)
  end

  def add_created_txt_files(dir, visible_files)
    txt_files = dir.each_file.select do |entry|
      entry.end_with?('.txt')
    end
    txt_files.each do |filename|
      visible_files[filename] = dir.read(filename)
    end
  end

  def remove_deleted_txt_files(dir, visible_files)
    all_files = dir.each_file.entries
    visible_files.delete_if do |filename, value|
      filename.end_with?('.txt') && !all_files.include?(filename)
    end
  end

end

# - - - - - - - - - - - - - - - - - - - -
# lowlight_filenames
# - - - - - - - - - - - - - - - - - - - -
# Caters for two uses
# 1. carefully constructed set of start files
#    (like James Grenning uses)
#    with explicitly set highlight_filenames entry 
#    in manifest
# 2. default set of files direct from languages/
#    viz, no highlight_filenames entry in manifest
# - - - - - - - - - - - - - - - - - - - -

