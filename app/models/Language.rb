
class Language

  def initialize(dojo, name)
    @dojo,@name = dojo,name
  end

  attr_reader :dojo, :name

  def exists?
    paas.exists?(self)
  end

  def runnable?
    paas.runnable?(self)
  end

  def display_name
    manifest['display_name'] || @name
  end

  def display_test_name
    manifest['display_test_name'] || unit_test_framework
  end

  def image_name
    manifest['image_name'] || ""
  end

  def visible_files
    Hash[visible_filenames.collect{ |filename|
      [ filename, read(filename) ]
    }]
  end

  def support_filenames
    manifest['support_filenames'] || [ ]
  end

  def highlight_filenames
    manifest['highlight_filenames'] || [ ]
  end

  def lowlight_filenames
    # Catering for two uses
    # 1. carefully constructed set of start files (like James Grenning uses)
    #    with explicitly set highlight_filenames entry in manifest
    # 2. default set of files direct from languages/
    #    viz, no highlight_filenames entry in manifest
    if highlight_filenames.length > 0
      return visible_filenames - highlight_filenames
    else
      return ['cyber-dojo.sh', 'makefile']
    end
  end

  def unit_test_framework
    manifest['unit_test_framework']
  end

  def tab
    " " * tab_size
  end

  def tab_size
    manifest['tab_size'] || 4
  end

  def visible_filenames
    manifest['visible_filenames'] || [ ]
  end

  def manifest
    @manifest ||= JSON.parse(read('manifest.json'))
  end

private

  def read(filename)
    paas.read(self, filename)
  end

  def paas
    dojo.paas
  end

end
