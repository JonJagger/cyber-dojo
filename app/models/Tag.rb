
# See comment at bottom of Avatar.rb

class Tag

  def initialize(avatar,n)
    @avatar,@n = avatar,n
  end

  def visible_files
    @manifest ||= JSON.parse(git(:show, "#{@n}:manifest.json"))
  end

  def output
    visible_files['output'] || ''
  end

private

  def path
    @avatar.path
  end

  include ExternalDisk
  include ExternalGit

end

#------------------------------------------
# output
#------------------------------------------
# In very early dojos avatar.create_kata()
# did not save 'output' in visible_files
#------------------------------------------

