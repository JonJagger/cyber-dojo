
# mimics state in browser

class ParamsMaker

  def initialize(avatar)
    @incoming = {} # what browser receives
    @current = {} # what browser submits
    avatar.visible_files.each do |filename, content|
      @incoming[filename] = content
      @current[filename] = content
    end
  end

  def new_file(filename, content)
    refute_file(filename, 'new_file')
    @current[filename] = content
  end

  def delete_file(filename)
    assert_file(filename, 'delete_file')
    @current.delete(filename)
  end

  def change_file(filename, content)
    assert_file(filename, 'change_file')
    message = [ info(filename, 'change_file'), "\t unchanged!" ].join("\n")
    refute(message) { @current[filename] == content }
    @current[filename] = content
  end

  def params
    result = {
      file_content: @current,
      file_hashes_incoming: @incoming,
      file_hashes_outgoing: @current
    }
    # called at test() only
    @incoming = {}
    @current.each do |filename, content|
      @incoming[filename] = content
    end
    result
  end

private

  def assert_file(filename, cmd)
    message = [
      info(filename, cmd),
      "\t no file with that name",
      "\t filenames are: #{filenames}"
    ].join("\n")
    assert(message) { file?(filename) }
  end

  def refute_file(filename, cmd)
    message = [
      info(filename,cmd),
      "\t already a file with that name"
    ].join("\n")
    refute(message) { file?(filename) }
  end

  def info(filename, cmd)
    self.class.name + ".#{cmd}(#{filename})"
  end

  def file?(filename)
    filenames.include?(filename)
  end

  def filenames
    @current.keys
  end

  def assert(message, &block)
    fail message unless block.call
  end

  def refute(message, &block)
    fail message if block.call
  end

end
