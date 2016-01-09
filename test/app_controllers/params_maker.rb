require 'digest/md5'

class ParamsMaker

  def initialize(avatar)
    @visible_files = avatar.visible_files
    @incoming,@outgoing = {},{}
    avatar.visible_files.each do |filename,content|
      @incoming[filename] = hash(content)
      @outgoing[filename] = hash(content)
    end
  end

  def new_file(filename, content)
    refute_file(filename, 'new_file')
    @visible_files[filename] = content
    @outgoing[filename] = hash(content)
  end

  def delete_file(filename)
    assert_file(filename, 'delete_file')
    @visible_files.delete(filename)
    @outgoing.delete(filename)
  end

  def change_file(filename, content)
    assert_file(filename, 'change_file')
    message = [ info(filename, 'change_file'), "\t unchanged!" ].join("\n")
    refute(message) { @visible_files[filename] == content }
    @visible_files[filename] = content
    @outgoing[filename] = hash(content)
  end

  def params
    {
      file_content: @visible_files,
      file_hashes_incoming: @incoming,
      file_hashes_outgoing: @outgoing
    }
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
    @visible_files.keys
  end

  def assert(message, &block)
    fail message unless block.call
  end

  def refute(message, &block)
    fail message if block.call
  end

  def hash(content)
    Digest::MD5.hexdigest(content)
  end

end
