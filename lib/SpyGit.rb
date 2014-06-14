
class SpyGit

  def initialize
    @log = { }
  end

  def log
    @log
  end

  def init(dir, options)
    spy(dir, 'init', options)
  end

  def add(dir, what)
    spy(dir, 'add', what)
  end

  def rm(dir, what)
    spy(dir, 'rm', what)
  end

  def commit(dir, options)
    spy(dir, 'commit', options)
  end

  def tag(dir, options)
    spy(dir, 'commit', options)
  end

  def show(dir, options)
    spy(dir, "show", options)
  end

  def diff(dir, options)
    spy(dir, "diff", options)
  end

private

  def spy(dir, command, options)
    @log[dir] ||= [ ]
    @log[dir] << [command, options]
    "{:hack=>'yes'}"
  end

end
