require File.dirname(__FILE__) + '/spy_dir'

class SpyDisk

  def initialize
    @symlink_log = [ ]
    @dir_spies = { }
  end

  attr_reader :symlink_log

  def teardown
    @dir_spies.each { |_dir,spy| spy.teardown }
  end

  def dir_separator
    '/'
  end

  def is_dir?(name)
    @dir_spies.any? { |dir,_spy| dir.start_with?(name) }
  end

  def dirs_each(from)
    dirs = [ ]
    @dir_spies.each_key{ |dir|
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
    @dir_spies[name] ||= SpyDir.new(self, name)
  end

  def symlink(old_name, new_name)
    @symlink_log << ['symlink', old_name, new_name]
  end

end
