# See cyber-dojo-model.pdf

class Dojo

  def languages; @languages ||= Languages.new(self); end
  def exercises; @exercises ||= Exercises.new(self); end

  def    runner;    @runner ||= external_object; end
  def     katas;     @katas ||= external_object; end
  def     shell;     @shell ||= external_object; end
  def      disk;      @disk ||= external_object; end
  def       log;       @log ||= external_object; end
  def       git;       @git ||= external_object; end

  def env_name(key, suffix) #
    'CYBER_DOJO_' + key.upcase + '_' + suffix.upcase
  end

  def env(key, suffix)
    name = env_name(key, suffix)
    ENV[name] || fail("ENV[#{name}] not set")
  end

  private

  include NameOfCaller

  def external_object
    key = name_of(caller)
    var = env(key, 'class')
    Object.const_get(var).new(self)
  end

end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# External root-dirs and class-names do *not* have defaults.
# Root-dirs and class-name are set using environment variables.
#   eg  export CYBER_DOJO_KATAS_ROOT=/var/www/cyber-dojo/katas
#   eg  export CYBER_DOJO_RUNNER_CLASS=DockerTarPipeRunner
#
# This gives a way to do Parameterize From Above in a way that can
# tunnel through a *deep* stack. For example, I can set an environment
# variable and then run a controller test,
# which issues GETs/POSTs, which work their way through the rails stack,
# eventually reaching app/models.dojo.rb (possibly in a different thread)
# where the specific Double/Mock/Stub class or fake-root-path takes effect.
#
# The external objects are held using
#    @name ||= ...
# I use ||= partly for optimization and partly for testing
# (where it is handy that it is the same object)
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
