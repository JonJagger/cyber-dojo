
class DirFake

  def initialize(disk,dir)
    @disk,@dir = disk,dir
  end

  def path
    @dir
  end

  def each_dir
    return enum_for(:each_dir) unless block_given?
    @disk.subdirs_each(self) do |subdir|
      yield subdir
    end
  end

  def each_file
    return enum_for(:each_file) unless block_given?
    (@repo || {}).keys.each do |filename|
      yield filename
    end
  end

  def make
    @repo ||= { }
  end

  def delete(filename)
    return if @repo.nil?
    @repo.delete(filename)
  end

  def exists?(filename = '')
    matches = @disk.dirs.keys.select {|d| d != path && d.start_with?(path) }
    return true  if filename === '' && !@repo.nil?
    return true  if filename === '' && !matches.empty?
    return false if filename === ''
    return false if @repo.nil?
    return !@repo[filename].nil?
  end

  def write_raw(filename,content)
    make
    @repo[filename] = content
  end

  def write(filename, content)
    if filename.end_with?('.rb')
      assert_not_string(content,filename)
      content = content.inspect
    end
    if filename.end_with?(".json")
      assert_not_string(content,filename)
      content = JSON.unparse(content)
    end
    make
    @repo[filename] = content
  end

  def read(filename)
    assert !@repo.nil?, "read('#{filename}') no file"
    assert !@repo[filename].nil?, "read('#{filename}') no file"
    content = @repo[filename]
    content
  end

  def lock(&block)
    block.call
  end

private

  def assert_not_string(content,filename)
    assert content.class != String,
      "write('#{filename}',content.class != String)"
  end

  def assert(truth, message)
    raise "FakeDir['#{@dir}'].#{message}" if !truth
  end

end
