require 'fileutils'

class Dir

  def initialize(disk,path)
    @disk,@path = disk,path
    @path += separator unless @path.end_with?(separator)
  end

  attr_reader :path

  def each_dir
    return enum_for(:each_dir) unless block_given?
    Dir.entries(path).each do |name|
      yield name
    end
  end

  def exists?(filename = nil)
    return File.directory?(path) if filename.nil?
    return File.exists?(path + filename)
  end

  def make
    # mkdir -p creates intermediate dirs as required
    FileUtils.mkdir_p(path)
  end

  def write(filename, object)
    pathed_filename = path + filename
    FileUtils.mkdir_p(File.dirname(pathed_filename))
    # The filename could be pathed, eg abc/def.hpp
    # if I allow pathed filenames to be entered from
    # the browser (or via language manifests?).
    # Not currently working though...
    if object.is_a? String
      File.open(pathed_filename, 'w') { |fd| fd.write(object) }
      execute = 0755
      File.chmod(execute, pathed_filename) if pathed_filename.end_with?('.sh')
    else
      File.open(pathed_filename, 'w') { |file|
        file.write(JSON.unparse(object)) if filename.end_with?('.json')
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

private

  def separator
    @disk.dir_separator
  end

end
