require File.dirname(__FILE__) + '/spy_dir'

class SpyDisk

  def initialize
    @symlink_log = [ ]
    @dir_spies = { }
  end

  def teardown
    @dir_spies.each { |dir,spy| spy.teardown }
  end

  def dir_separator
    '/'
  end

  def is_dir?(name)
    @dir_spies[name + '/']
  end

  def dirs_each(from)
    @dir_spies.each do |dir,spy|
      if dir != from.path && dir.start_with?(from.path)
        sub = dir[from.path.length..-1]
        if sub.end_with?(dir_separator)
          sub = sub[0..-2]
        end
        yield sub
      end
    end
  end

  def [](name)
    @dir_spies[name] ||= SpyDir.new(self, name)
  end

  def symlink(old_name, new_name)
    @symlink_log << ['symlink', old_name, new_name]
  end

  def symlink_log
    @symlink_log
  end

end
