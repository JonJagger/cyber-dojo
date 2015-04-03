
# See cyber-dojo-model.pdf

class Dojo

  def languages
    @languages ||= Languages.new(self, external_path(cd('LANGUAGES_ROOT')))
  end

  def exercises
    @exercises ||= Exercises.new(self, external_path(cd('EXERCISES_ROOT')))
  end

  def katas
    @katas ||= Katas.new(self, external_path(cd('KATAS_ROOT')))
  end

  #one_self
  
  def runner
    @runner ||= new_obj(external(cd('RUNNER_CLASS_NAME')))
  end

  def disk
    @disk ||= new_obj(external(cd('DISK_CLASS_NAME')))
  end

  def git(args)
    @git ||= new_obj(external(cd('GIT_CLASS_NAME')))
    command = args.delete_at(1)
    @git.send(command,args)    
  end

private

  def new_obj(name)
    Object.const_get(name).new  
  end
  
  def external_path(key)
    result = external(key)
    raise RuntimeError.new("ENV['#{key}']='#{result}' must end in /") if !result.end_with? '/'
    result
  end
  
  def external(key)
    result = ENV[key]
    raise RuntimeError.new("ENV['#{key}'] not set") if result.nil?
    result
  end
  
  def cd(key)
    'CYBER_DOJO_' + key
  end
  
end
