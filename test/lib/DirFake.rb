
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

  def each_kata_id
    return enum_for(:each_kata_id) unless block_given?
    @disk[path].each_dir do |outer_dir|
      @disk[path + outer_dir].each_dir do |inner_dir|
        yield outer_dir + inner_dir
      end
    end    
  end

  def complete_kata_id(id)
    # TODO: untested. exact duplicate from HostDir. Refactor into included module?
    if !id.nil? && id.length >= 4
      id.upcase!
      inner_dir = @disk[path + id[0..1]]
      if inner_dir.exists?
        dirs = inner_dir.each_dir.select { |outer_dir|
          outer_dir.start_with?(id[2..-1])
        }
        id = id[0..1] + dirs[0] if dirs.length === 1
      end
    end
    id || ''
  end
  
  def make
    @repo ||= { }
  end

  def delete(filename)
    return if @repo.nil?
    @repo.delete(filename)
  end

  def exists?(filename = nil)
    matches = @disk.dirs.keys.select {|d| d != path && d.start_with?(path) }
    return true  if filename.nil? && !@repo.nil?
    return true  if filename.nil? && !matches.empty?
    return false if filename.nil?
    return false if @repo.nil?
    return !@repo[filename].nil?
  end

  def write_json(filename, object)
    assert filename.end_with?('.json'), "#{filename}.end_with?('.json')"
    make
    @repo[filename] = JSON.unparse(object)
  end

  def write(filename, s)
    assert s.is_a?(String), "#write(#{filename},s) s.is_a?(String)"
    make
    @repo[filename] = s
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
    raise "DirFake['#{@dir}'].#{message}" if !truth
  end

end
