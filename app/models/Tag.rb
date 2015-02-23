
# See comment at bottom of Avatar.rb

class Tag

  def initialize(avatar,n)
    @avatar,@n = avatar,n
  end

  def visible_files
    @manifest ||= JSON.parse(git(:show, "#{@n}:manifest.json"))
  end

  def output
    # tag 0's manifest (start_avatar commit)
    # does not have an output file
    visible_files['output'] || ''
  end

private

  def path
    @avatar.path
  end

  include ExternalDiskDir
  include ExternalGit

end
