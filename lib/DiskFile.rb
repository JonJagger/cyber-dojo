
class DiskFile

  def separator
    File::SEPARATOR
  end
  
  def write(dir, filename, object)
    pathed_filename = dir + separator + filename
    make_dir(pathed_filename) # if file is in a dir make the dir
    if object.is_a? String
      File.open(pathed_filename, 'w') do |fd|
        fd.write(makefile_filter(pathed_filename, object))
      end
      # .sh files (eg cyber-dojo.sh) need execute permissions
      File.chmod(0755, pathed_filename) if pathed_filename =~ /\.sh/    
    else
      # When doing a git diff on a repository that includes files created
      # by this function I found the output contained extra lines thus
      # \ No newline at end of file
      # So I've appended a newline to help keep git quieter.
      File.open(pathed_filename, 'w') { |file| file.write(object.inspect + "\n") }
    end    
  end
  
  def read(dir, filename)
    IO.read(dir + separator + filename)
  end
  
  def symlink(old_name, new_name)
   File.symlink(old_name, new_name)
  end
  
  def directory?(dir)
    File.directory?(dir)
  end
  
  def exists?(dir, filename = "")    
    File.exists?(dir + separator + filename)
  end
  
  def lock(dir, &block)
    # io locking uses blocking call.
    # For example, when a player starts-coding then
    # the controller needs to wait to acquire a lock on
    # the dojo folder before choosing an avatar.    
    # See test/lib/io_lock_tests.rb
    result = nil
    File.open(dir + separator + 'f.lock', "w") do |fd|
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

  def make_dir(dir)
    if dir[-1] != '/'
      dir = File.dirname(dir)
    end
    # the -p option creates intermediate dirs as required
    command = "mkdir -p #{dir}"
    system(command)
  end
  
  def makefile_filter(pathed_filename, content)
    # The jquery-tabby.js plugin intercepts tab key presses in the
    # textarea editor and converts them to spaces for a better
    # editing experience. However, makefiles are tab sensitive...
    # Hence this special filter, just for makefiles, to convert
    # leading spaces back to a tab character.
    if pathed_filename.downcase.split(separator).last == 'makefile'
      lines = [ ]
      newline = Regexp.new('[\r]?[\n]')
      content.split(newline).each do |line|
        if stripped = line.lstrip!
          line = "\t" + stripped
        end
        lines.push(line)
      end
      content = lines.join("\n")
    end
    content
  end
  
end
