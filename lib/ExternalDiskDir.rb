
module ExternalDiskDir # mixin
  
  def dir
    disk[path]
  end

  def disk
    external(:disk)
  end

private
  
  include External

end
