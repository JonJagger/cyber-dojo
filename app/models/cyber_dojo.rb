
# can't call it CyberDojo presumably because something else
# is already called that from the rails app name

class Cyber_Dojo
  
  def initialize(dir)
    @dir = dir
  end

  def dir
    @dir
  end
  
  def [](id)
    Kata.new(@dir,id)
  end
  
  def language(name)
    Language.new(@dir,name)
  end
  
end
