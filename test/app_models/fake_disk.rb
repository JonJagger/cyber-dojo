require File.dirname(__FILE__) + '/fake_dir'

class FakeDisk

  def initialize
    @symlink_log = [ ]
    @dir_fakes = { }
  end

  attr_reader :symlink_log

  def dir_separator
    '/'
  end

  def is_dir?(path)
    @dir_fakes.any? {|dir,_spy| dir.start_with?(slashed(path))}
  end

  def dirs_each(fake_dir)                                       # spied/
    dirs = [ ]
    @dir_fakes.each_key{ |dir|                                  # spied/a/b/
      if dir != fake_dir.path && dir.start_with?(fake_dir.path)
        sub = dir[fake_dir.path.length..-1]                     #       a/b
        last = sub.index(dir_separator) - 1
        dirs << sub[0..last]                                    #       a
      end
    }
    dirs.sort.uniq.each do |dir|
      yield dir if block_given?
    end
  end

  def [](path)
    path = slashed(path)
    @dir_fakes[path] ||= FakeDir.new(self, path)
  end

  def symlink(old_name, new_name)
    @symlink_log << ['symlink', old_name, new_name]
  end

private

  def slashed(path)
    path[-1] === dir_separator ? path : path + dir_separator
  end

end
