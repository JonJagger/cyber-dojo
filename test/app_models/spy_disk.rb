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

  def is_dir?(path)
    @dir_spies.any? {|dir,_spy| dir.start_with?(slashed(path))}
  end

  def dirs_each(spy_dir)                                       # spied/
    dirs = [ ]
    @dir_spies.each_key{ |dir|                                 # spied/a/b/
      if dir != spy_dir.path && dir.start_with?(spy_dir.path)
        sub = dir[spy_dir.path.length..-1]                     #       a/b
        last = sub.index(dir_separator) - 1
        dirs << sub[0..last]                                   #       a
      end
    }
    dirs.sort.uniq.each do |dir|
      yield dir if block_given?
    end
  end

  def [](path)
    path = slashed(path)
    @dir_spies[path] ||= SpyDir.new(self, path)
  end

  def symlink(old_name, new_name)
    @symlink_log << ['symlink', old_name, new_name]
  end

private

  def slashed(path)
    path[-1] === dir_separator ? path : path + dir_separator
  end

end
