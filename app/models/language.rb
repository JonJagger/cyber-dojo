
class Language

  def initialize(dojo, name)
    @disk = Thread.current[:disk] || fatal
    @dojo = dojo
    @name = name
  end

  def name
    @name
  end

  def path
    @dojo.dir.path + dir_separator + 'languages' + dir_separator + name
  end

  def dir
    @disk[path]
  end

  def exists?
    dir.exists?
  end

  def visible_files
    Hash[visible_filenames.collect{|filename| [filename, dir.read(filename)]}]
  end

  def support_filenames
    manifest['support_filenames'] || [ ]
  end

  def highlight_filenames
    manifest['highlight_filenames'] || [ ]
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

private

  def fatal
    raise "no disk"
  end

  def dir_separator
    @disk.dir_separator
  end

  def visible_filenames
    manifest['visible_filenames'] || [ ]
  end

  def manifest
    @manifest = JSON.parse(dir.read('manifest.json'))
  end

end
