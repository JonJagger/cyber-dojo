
# See cyber-dojo-model.pdf

class Dojo

  def languages
    @languages ||= Languages.new(self, languages_path)
  end

  def exercises
    @exercises ||= Exercises.new(self, exercises_path)
  end

  def katas
    @katas ||= Katas.new(self, katas_path)
  end

  #one_self
  
  def runner
    @runner ||= external('RUNNER_NAME')
  end

  def disk
    @disk ||= external('DISK_NAME')
  end

  def git
    @git ||= external('GIT_NAME')
  end

private

  def languages_path
    checked('LANGUAGES_PATH')
  end

  def exercises_path
    checked('EXERCISES_PATH')
  end

  def katas_path
    checked('KATAS_PATH')
  end

  def external(name)
    Object.const_get(checked(name)).new  
  end
  
  def checked(name)
    name = 'CYBER_DOJO_' + name
    raise RuntimeError("ENV['#{name}'] not set") if ENV[name].nil?
    ENV[name]
  end
  
end
