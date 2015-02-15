
module ExternalGit # mixin

  def git
    external(:git)
  end

  def git_init(args)
    git.init(path,args)
  end
  
  def git_config(args)
    git.init(path,args)
  end
  
  def git_add(args)
    git.add(path,args)
  end
  
  def git_rm(args)
    git.rm(path,args)
  end
  
  def git_commit(args)
    git.commit(path,args)
  end
    
  def git_gc(args)
    git.gc(path,args)
  end
  
  def git_tag(args)
    git.tag(path,args)
  end
  
  def git_show(args)
    git.show(path,args)
  end
  
  def git_diff(args)
    git.diff(path,args)
  end
  
private

  include External

end
