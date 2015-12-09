# See comments at end of file

class Language

  def initialize(languages, dir_name, test_dir_name, display_name = nil, image_name = nil)
    @languages = languages
    @dir_name = dir_name
    @test_dir_name = test_dir_name
    @display_name = display_name
    @image_name = image_name
  end

  # queries

  attr_reader :languages

  def parent
    languages
  end

  def path
    languages.path + @dir_name + '/' + @test_dir_name + '/'
  end

  # required manifest properties

  def display_name
    # cached to optimize displaying all languages on cyber-dojo create
    @display_name ||= manifest_property
  end

  def image_name
    # cached to optimize displaying all languages on cyber-dojo create
    @image_name ||= manifest_property
  end

  def unit_test_framework
    manifest_property
  end

  def visible_filenames
    manifest_property || []
  end

  def visible_files
    Hash[visible_filenames.collect { |filename| [filename, read(filename)] }]
  end

  # optional manifest properties

  def filename_extension
    manifest_property || ''
  end

  def highlight_filenames
    manifest_property || []
  end

  def progress_regexs
    manifest_property || []
  end

  def tab_size
    manifest_property || 4
  end

  # not manifest properties

  def tab
    ' ' * tab_size
  end

  def lowlight_filenames
    if highlight_filenames.empty?
      ['cyber-dojo.sh', 'makefile', 'Makefile', 'unity.license.txt']
    else
      visible_filenames - highlight_filenames
    end
  end

  def name
    # as stored in the kata's manifest
    display_name.split(',').map(&:strip).join('-')
  end

  def colour(output)
    OutputColour.of(unit_test_framework, output)
  end

  private

  include ExternalParentChainer
  include ExternalDir
  include ManifestProperty

  def manifest
    @manifest ||= read_json(manifest_filename)
  rescue StandardError => e
    message = "read_json(#{manifest_filename}) exception" + "\n" +
      'language: ' + path + "\n" +
      ' message: ' + e.message
    fail message
  end

  def manifest_filename
    'manifest.json'
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
