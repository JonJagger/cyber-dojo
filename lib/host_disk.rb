
class HostDisk

  def dir_separator
    File::SEPARATOR
  end

  def dir?(name)
    File.directory?(name)
  end

  def [](name)
    HostDir.new(self, name)
  end

end
