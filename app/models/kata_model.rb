
class KataModel

  def initialize(id)
    @id = id
  end

  def folder
    'katas' + '/' + @id
  end

  def exercise
    ExerciseModel.new(self)
  end

  def avatar(name)
    AvatarModel.new(self, name)
  end

  def avatars
    result = []
    AvatarModel::NAMES.each do |avatar_name|
      path = folder + '/' + avatar_name
      result << avatar(avatar_name) if File.exists?(path)
    end
    result
  end

end



