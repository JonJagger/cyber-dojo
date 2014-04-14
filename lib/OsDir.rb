require 'fileutils'

class OsDir
  include Enumerable

  def initialize(disk,path)
    @disk,@path = disk,path
    dir_separator = @disk.dir_separator
    if @path[-1] != dir_separator
      @path += dir_separator
    end
  end

  def path
    @path
  end

  def each
    Dir.entries(path).select do |name|
      yield name
    end
  end

  def exists?(filename = nil)
    if filename == nil
      return File.directory?(path)
    else
      return File.exists?(path + filename)
    end
  end

  def make
    # the p option creates intermediate dirs as required
    FileUtils.mkdir_p(path)
  end

  def write(filename, object)
    pathed_filename = path + filename
    FileUtils.mkdir_p(File.dirname(pathed_filename))
    if object.is_a? String
      File.open(pathed_filename, 'w') do |fd|
        fd.write(object)
      end
      execute_permission = 0755
      File.chmod(execute_permission, pathed_filename) if pathed_filename =~ /\.sh/
    else
      File.open(pathed_filename, 'w') { |file|
        if filename.end_with?('.rb')
          file.write(object.inspect)
        end
        if filename.end_with?('.json')
          file.write(JSON.unparse(object))
        end
      }
    end
  end

  def read(filename)
    IO.read(path + filename)
  end

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

end
