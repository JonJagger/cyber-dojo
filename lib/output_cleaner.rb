
module OutputCleaner # mix-in

  module_function

  def cleaned(output)
    # force an encoding change - if encoding is already utf-8
    # then encoding to utf-8 is a no-op and invalid byte
    # sequences are not detected.
    output = output.encode('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
    output = output.encode('UTF-8', 'UTF-16')
  end

end

# http://robots.thoughtbot.com/fight-back-utf-8-invalid-byte-sequences
