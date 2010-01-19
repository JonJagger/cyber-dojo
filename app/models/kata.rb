
class Kata

  def initialize(id)
    @id = id
  end

  def folder
    'katas' + '/' + @id
  end

  def exercise
    Exercise.new(self)
  end

  def avatar(name)
    Avatar.new(self, name)
  end

  def avatars
    result = []
    Avatar::NAMES.each do |avatar_name|
      path = folder + '/' + avatar_name
      result << avatar(avatar_name) if File.exists?(path)
    end
    result
  end

end



