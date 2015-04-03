
# comments at end of file
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

  def git(*args)
    @git ||= new_obj(external(cd('GIT_CLASS_NAME')))
    command = args.delete_at(1)
    @git.send(command,*args)    
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

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# External paths/objects are set from environment variables
# (see config/initializers/externals.rb)
# There main reason for this arrangment is testability.
# It allows me to do polymorphic testing, viz to run
# the *same* multiple times under different environments.
# For example, I could run a test with all the externals mocked
# out (a true unit test) and then run the same test again with
# the true externals in place (an integration/system test).
#
# It also greatly expands the reach of the tests I can perform.
# For example, I can run controller tests in the same
# polymorphic testing manner: set the environment variables,
# then run the test which issue a GET/POST, let the call
# work its way through the rails stack, eventually getting
# back to Dojo.rb where it picks up the externals as setup.
#
# I cannot see how how I do this using Parameterize From Above
# since I know of no way to 'tunnel' the parameters 'through'
# the rails stack.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
