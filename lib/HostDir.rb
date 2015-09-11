require 'fileutils'

class HostDir

  def initialize(disk,path)
    @disk,@path = disk,path
    @path += separator unless @path.end_with?(separator)
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
      yield entry if !@disk.dir?(pathed)
    end
  end

  def exists?(filename = nil)
    return File.directory?(path) if filename.nil?
    return File.exists?(path + filename)
  end

  def make
    FileUtils.mkdir_p(path) # creates intermediate dirs as required
  end

  def write(filename, object)
    # The filename could be pathed, eg a/b/c/def.hpp if I
    # allowed pathed filenames to be entered from the browser
    # (or via language manifests) which I currently don't.
    pathed_filename = path + filename
    FileUtils.mkdir_p(File.dirname(pathed_filename))
    if object.is_a? String
      File.open(pathed_filename, 'w') { |fd| fd.write(object) }
      File.chmod(execute=0755, pathed_filename) if pathed_filename.end_with?('.sh')
    else
      File.open(pathed_filename, 'w') { |file|
        file.write(JSON.unparse(object)) if filename.end_with?('.json')
      }
    end
  end

  def read(filename)
    clean(IO.read(path + filename))
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def lock(&block)
    # io locking uses blocking call.
    # For example, when a player starts-coding then
    # the controller needs to wait to acquire a lock on
    # the dojo folder before choosing an avatar.
    result = nil
    File.open(path + 'f.lock', 'w') do |fd|
      if fd.flock(File::LOCK_EX)
        begin
          result = block.call()
        ensure
          fd.flock(File::LOCK_UN)
        end
      end
    end
    result
  end

private

  include Cleaner

  def dot?(name)
    name.end_with?('/.') || name.end_with?('/..')
  end

  def separator
    @disk.dir_separator
  end

end
