
module ExternalDir # mix-in

  module_function

  def dir
    disk[path]
  end

  def exists?(filename = nil)
    dir.exists?(filename)
  end

  def read(filename)
    dir.read(filename)
  end

  def read_json(filename)
    dir.read_json(filename)
  end

  def write(filename, content)
    dir.write(filename, content)
  end

  def write_json(filename, object)
    dir.write_json(filename, object)
  end

end
