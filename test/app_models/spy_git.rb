
class SpyGit

  def initialize
    @log = { }
  end

  def log
    @log
  end

  def init(dir, options)
    store(dir, 'init', options)
  end

  def add(dir, what)
    store(dir, 'add', what)
  end

  def rm(dir, what)
    store(dir, 'rm', what)
  end

  def commit(dir, options)
    store(dir, 'commit', options)
  end

  def tag(dir, options)
    store(dir, 'commit', options)
  end

  def show(dir, options)
    store(dir, "show", options)
  end

  def diff(dir, options)
    store(dir, "diff", options)
  end

private

  def store(dir, command, options)
    @log[dir] ||= [ ]
    @log[dir] << [command, options]
    "{:hack=>'yes'}"
  end

end
