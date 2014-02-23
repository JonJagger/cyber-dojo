
require 'Disk'

class Exercise

  def initialize(dojo, name)
    @disk = Thread.current[:disk] || Disk.new
    @dojo = dojo
    @name = name
  end

  def exists?
    @disk.exists?(dir)
  end

  def dir
    @dojo.dir + dir_separator + 'exercises' + dir_separator + name
  end

  def name
    @name
  end

  def instructions
    @disk[dir].read('instructions')
  end

private

  def dir_separator
    @disk.dir_separator
  end

end
