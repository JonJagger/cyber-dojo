
class Kata

  def initialize(id, name="")
    @id = id
    @manifest = eval IO.read(folder + '/' + 'kata_manifest.rb')
    @avatar = Avatar.new(self, name) if name != ""
    @readonly = false
  end

  def readonly
    @readonly
  end

  def readonly=(tf)
    @readonly = tf
  end

  def id
    @id.to_s
  end

  def language
    @manifest[:language].to_s
  end

  def exercise_name
    @manifest[:exercise].to_s
  end

  def max_run_tests_duration
    @manifest[:max_run_tests_duration].to_i
  end

  def exercise
    Exercise.new(self)
  end

  def avatar
    @avatar
  end

  def avatars
    result = []
    Avatar.names.each do |avatar_name|
      path = folder + '/' + avatar_name
      result << Avatar.new(self,avatar_name) if File.exists?(path)
    end
    result
  end

  def folder
    'katas' + '/' + id
  end

end



