require 'fileutils'

class HostDir

  def initialize(disk, path)
    @disk = disk
    @path = path
    @path += '/' unless @path.end_with?('/')
  end

  attr_reader :path

  def each_dir
    return enum_for(:each_dir) unless block_given?
    Dir.entries(path).each do |entry|
      pathed = path + entry
      yield entry if @disk.dir?(pathed) && !dot?(pathed)
    end
  end

  def each_file
    return enum_for(:each_file) unless block_given?
    Dir.entries(path).each do |entry|
      pathed = path + entry
      yield entry unless @disk.dir?(pathed)
    end
  end

  def exists?(filename = nil)
    return File.directory?(path) if filename.nil?
    return File.exists?(path + filename)
  end

  def make
    # -p creates intermediate dirs as required.
    FileUtils.mkdir_p(path)
  end

  def write_json(filename, object)
    fail RuntimeError.new("#{filename} doesn't end in .json") unless filename.end_with? '.json'
    write(filename, JSON.unparse(object))
  end

  def write(filename, s)
    fail RuntimeError.new('not a string') unless s.is_a? String
    pathed_filename = path + filename
    File.open(pathed_filename, 'w') { |fd| fd.write(s) }
    File.chmod(0755, pathed_filename) if pathed_filename.end_with?('.sh')
  end

  def read_json(filename)
    fail RuntimeError.new("#{filename} doesn't end in .json") unless filename.end_with? '.json'
    JSON.parse(read(filename))
  end

  def read(filename)
    cleaned(IO.read(path + filename))
  end

  private

  include StringCleaner

  def dot?(name)
    name.end_with?('/.') || name.end_with?('/..')
  end

end
