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

  def [](dir)
    @dir_spies[dir] ||= SpyDir.new(dir)
  end

  def symlink(old_name, new_name)
    @symlink_log << ['symlink', old_name, new_name]
  end

  def symlink_log
    @symlink_log
  end

end
