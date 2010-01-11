
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

  #TODO: iterations needs return an IterationsModel object?
  def iterations
    eval locked_read(folder + '/' + 'iterations_manifest.rb')
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

#===============================================================

def locked_read(path)
  result = []
  File.open(path, 'r') do |f|
    flock(f) { |lock| result = IO.read(path) }
  end
  result
end

def flock(file)
  success = file.flock(File::LOCK_EX)
  if success
    begin
      yield file
    ensure
      file.flock(File::LOCK_UN)
    end
  end
  return success
end


