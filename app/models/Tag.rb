
# See comment at bottom of Avatar.rb

class Tag
  include ExternalParentChain

  def initialize(avatar,n)
    @parent,@n = avatar,n
  end

  def visible_files
    @manifest ||= JSON.parse(git.show(path, "#{@n}:manifest.json"))
  end

  def output
    visible_files['output'] || ''
  end

  def number
    @n
  end
  
private

  def path
    @parent.path
  end

end

#------------------------------------------
# output
#------------------------------------------
# In very early dojos katas.create_kata()
# did not save 'output' in visible_files
#------------------------------------------

