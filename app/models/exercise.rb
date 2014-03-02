
class Exercise

  def initialize(dojo, name)
    @disk = Thread.current[:disk] || fatal("no disk")
    @dojo,@name = dojo,name
  end

  def name
    @name
  end

  def path
    @dojo.path + 'exercises' + dir_separator + name + dir_separator
  end

  def dir
    @disk[path]
  end

  def exists?
    dir.exists?
  end

  def instructions
    dir.read('instructions')
  end

private

  def fatal(diagnostic)
    raise diagnostic
  end

  def dir_separator
    @disk.dir_separator
  end

end
