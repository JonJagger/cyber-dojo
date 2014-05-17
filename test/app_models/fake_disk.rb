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

  def is_dir?(name)
    @dir_fakes[name + '/']
  end

  def dirs_each(from)
    dirs = [ ]
    @dir_fakes.each_key{ |dir|
      if dir != from.path && dir.start_with?(from.path)
        sub = dir[from.path.length..-1]
        last = sub.index(dir_separator) || 0
        dirs << sub[0..(last-1)]
      end
    }
    dirs.sort.uniq.each do |dir|
      yield dir
    end
  end

  def [](name)
    @dir_fakes[name] ||= FakeDir.new(self, name)
  end

  def symlink(old_name, new_name)
    @symlink_log << ['symlink', old_name, new_name]
  end

end
