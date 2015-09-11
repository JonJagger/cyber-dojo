# See comments at end of file
# See cyber-dojo-model.pdf

class Dojo

  def languages
    @languages ||= Languages.new(self, external_root)
  end

  def exercises
    @exercises ||= Exercises.new(self, external_root)
  end

  def katas
    @katas ||= Katas.new(self, external_root)
  end

  def runner
    @runner ||= external_obj
  end

  def disk
    @disk ||= external_obj
  end

  def git
    @git ||= external_obj
  end

  def one_self
    @one_self ||= external_obj_pass_disk
  end
  
private

  def external_root
    external(name_of(caller) + '_ROOT')
  end
  
  def external_obj
    Object.const_get(external(name_of(caller) + '_CLASS')).new
  end

  def external_obj_pass_disk
    Object.const_get(external(name_of(caller) + '_CLASS')).new(disk)
  end
  
  def external(key)
    result = ENV[key]
    raise RuntimeError.new("ENV['#{key}'] not set") if result.nil?
    result
  end
  
  def name_of(caller)
    'CYBER_DOJO_' + (caller[0] =~ /`([^']*)'/ and $1).upcase
  end
    
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# External paths/class-names are set via environment variables.
# See config/application.rb (config.before_configuration)
#
# The main reason for this arrangement is testability.
# For example, I can run controller tests by setting the
# environment variables, then run the test which issue 
# a GET/POST, let the call work its way through the rails stack, 
# eventually reaching Dojo.rb where it creates
# Disk/Runner/Git/OneSelf objects as named in the ENV[]
# I cannot see how how I do this using Parameterize-From-Above
# since I know of no way to 'tunnel' the parameters 'through'
# the rails stack.
#
# It also allows me to do polymorphic testing, viz to run
# the *same* test multiple times under different environments.
# For example, I could run a test with all the externals mocked
# out (a true unit test) and then run the same test again with
# the true externals in place (an integration/system test).
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
