
# See cyber-dojo-model.pdf

class Dojo

  def initialize(path)
    raise RuntimeError.new("path must end in /") if !path.end_with?('/')
    @path = path
  end

  attr_reader :path
  
  def languages
    languages_path = @path + 'languages/'
    @languages ||= Languages.new(languages_path)
  end

  def exercises
    exercises_path = @path + 'exercises/'
    @exercises ||= Exercises.new(exercises_path)
  end

  def katas
    katas_path = @path
    if ENV['CYBERDOJO_TEST_ROOT_DIR']
      # see test/languages/one_language_checker.rb
      katas_path += 'test/cyberdojo/'
    end
    katas_path += 'katas/'
    Katas.new(self, katas_path)
  end

end
