
class Exercise

  def initialize(dojo, name)
    @disk = Thread.current[:disk] || fatal
    @dojo = dojo
    @name = name
  end

  def name
    @name
  end

  def path
    dir.path
  end

  def dir
    @disk[@dojo.path + dir_separator + 'exercises' + dir_separator + name]
  end

  def exists?
    dir.exists?
  end

  def instructions
    dir.read('instructions')
  end

private

  def fatal
    raise "no disk"
  end

  def dir_separator
    @disk.dir_separator
  end

end
