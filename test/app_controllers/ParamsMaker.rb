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

  def new_file(filename,content)
    refute { @visible_files.keys.include?(filename) }
    @visible_files[filename] = content
    @outgoing[filename] = hash(content)
  end

  def delete_file(filename)
    assert { @visible_files.keys.include?(filename) }
    @visible_files.delete(filename)
    @outgoing.delete(filename)
  end

  def change_file(filename,content)
    assert { @visible_files.keys.include?(filename) }
    refute { @visible_files[filename] == content }
    @visible_files[filename] = content
    @outgoing[filename] = hash(content)
  end

  def params
    {
      :file_content => @visible_files,
      :file_hashes_incoming => @incoming,
      :file_hashes_outgoing => @outgoing
    }
  end

private

  def hash(content)
    Digest::MD5.hexdigest(content)
  end

  def assert(&block)
    raise RuntimeError.new('DeltaMaker.assert') if !block.call
  end

  def refute(&block)
    raise RuntimeError.new('DeltaMaker.refute') if block.call
  end

end
