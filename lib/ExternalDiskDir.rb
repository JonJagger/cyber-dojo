
module ExternalDiskDir # mixin
  
  def dir
    disk[path]
  end

  def disk
    @disk ||= Object.const_get(disk_class_name).new
  end

  def disk?
    ['Disk','DiskFake'].include? disk_class_name
  end
  
  def disk_class_name
    ENV[disk_key]
  end
  
  def set_disk_class_name(value)
    ENV[disk_key] = value
  end
  
private
  
  def disk_key
    'CYBER_DOJO_DISK_CLASS_NAME'
  end

end
