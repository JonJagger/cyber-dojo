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
    # mkdir -p creates intermediate dirs as required
    FileUtils.mkdir_p(path)
  end

  def write(filename, object)
    pathed_filename = path + filename
    FileUtils.mkdir_p(File.dirname(pathed_filename))
    # The filename could be pathed, eg a/b/c/def.hpp if I
    # allowed pathed filenames to be entered from the browser
    # (or via language manifests) which I currently don't.
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
    clean(IO.read(path + filename))
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  def each_kata_id
    return enum_for(:each_kata_id) unless block_given?    
    @disk[path].each_dir do |outer_dir|
      @disk[path + outer_dir].each_dir do |inner_dir|
        yield outer_dir + inner_dir
      end
    end    
  end

  def complete_kata_id(id)
    if !id.nil? && id.length >= 4
      id.upcase!
      inner_dir = @disk[path + id[0..1]]
      if inner_dir.exists?
        dirs = inner_dir.each_dir.select { |outer_dir|
          outer_dir.start_with?(id[2..-1])
        }
        id = id[0..1] + dirs[0] if dirs.length === 1
      end
    end
    id || ''
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
