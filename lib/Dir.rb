
class Dir

  def initialize(disk,dir)
    @disk,@dir = disk,dir
    dir_separator = @disk.dir_separator
    if @dir[-1] != dir_separator
      @dir += dir_separator
    end
  end

  def exists?
    File.directory?(@dir)
  end

  def make
    # the -p option creates intermediate dirs as required
    `mkdir -p #{@dir}`
  end

  def write(filename, object)
    # filename could be pathed...
    pathed_filename = @dir + filename
    `mkdir -p #{File.dirname(pathed_filename)}`
    if object.is_a? String
      File.open(pathed_filename, 'w') do |fd|
        fd.write(object)
      end
      execute_permission = 0755
      File.chmod(execute_permission, pathed_filename) if pathed_filename =~ /\.sh/
    else
      # The newline is to silence git's "\ No newline at end of file"
      File.open(pathed_filename, 'w') { |file| file.write(object.inspect + "\n") }
    end
  end

  def read(filename)
    IO.read(@dir + filename)
  end

  def lock(&block)
    # io locking uses blocking call.
    # For example, when a player starts-coding then
    # the controller needs to wait to acquire a lock on
    # the dojo folder before choosing an avatar.
    result = nil
    File.open(@dir + 'f.lock', 'w') do |fd|
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
