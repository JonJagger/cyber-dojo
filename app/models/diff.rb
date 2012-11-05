
class Diff
  
  def initialize(manifest)
    @manifest = manifest
  end
  
  def id
    @manifest[:diff_id]
  end
  
  def avatar
    @manifest[:diff_avatar]
  end
  
  def tag
    @manifest[:diff_tag]
  end
  
end
