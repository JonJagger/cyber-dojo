
module MakefileFilter
  
  def self.filter(filename, content)
    # The jquery-tabby.js plugin intercepts tab key presses in the
    # textarea editor and converts them to spaces for a better
    # code editing experience. However, makefiles are tab sensitive...
    # Hence this special filter, just for makefiles, to convert
    # leading spaces back to a tab character.
    if filename.downcase.split(File::SEPARATOR).last == 'makefile'
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
