
module CodeSaver
  
  def self.save_file(dir, filename, content)
    path = dir + '/' + filename
    # No need to lock when writing these files.
    # They are write-once-only
    File.open(path, 'w') do |fd|
      fd.write(makefile_filter(filename, content))
    end
    # .sh files (eg cyberdojo.sh) need execute permissions
    File.chmod(0755, path) if filename =~ /\.sh/    
  end

  def self.makefile_filter(name, content)
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -    
    # makefiles are tab sensitive...
    # The CyberDojo editor intercepts tab keys and replaces them with spaces.
    # Hence this special filter, just for makefiles to convert leading spaces 
    # back to a tab character.
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -    
    if name.downcase == 'makefile'
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
