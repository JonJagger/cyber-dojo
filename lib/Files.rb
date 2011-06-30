module Files
  def file_write(path, object)
    # When doing a git diff on a repository that includes files created
    # by this function I found the output contained extra lines thus
    # \ No newline at end of file
    # So I've appended a newline to help keep git quieter.
    File.open(path, 'w') { |file| file.write object.inspect + "\n" }
  end
  
  def popen_read(cmd)  
    ios = IO::popen(with_stderr(cmd))
    begin
      output = ios.read
    ensure
      ios.close
    end
    output
  end
    
  def with_stderr(cmd)
    cmd + " " + "2>&1"
  end

end