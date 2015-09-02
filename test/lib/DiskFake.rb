
class DiskFake

  def dirs
    @dirs ||= { }
  end

  def dir_separator
    '/'
  end

  def is_dir?(path)
    dirs.keys.any? {|dir| dir.start_with?(slashed(path))}
  end

  def subdirs_each(root_dir)                                    # spied/
    subs = [ ]
    dirs.each_key{ |dir|                                        # spied/a/b/
      if dir != root_dir.path && dir.start_with?(root_dir.path)
        sub = dir[root_dir.path.length..-1]                     #       a/b
        last = sub.index(dir_separator) - 1
        subs << sub[0..last]                                    #   <<  a
      end
    }
    subs.sort.uniq.each do |dir|
      yield dir if block_given?
    end
  end

  def [](path)
    path = slashed(path)
    dirs[path] ||= make_dir(self, path)
  end

  def make_dir(disk,path)
    DirFake.new(disk,path)
  end

private

  def slashed(path)
    path.end_with?(dir_separator) ? path : path + dir_separator
  end

end
