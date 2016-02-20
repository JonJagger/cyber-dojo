# See cyber-dojo-model.pdf

class Dojo

  def languages; @languages ||= Languages.new(self, get_root('languages')); end
  def exercises; @exercises ||= Exercises.new(self, get_root('exercises')); end
  def    caches; @caches    ||=    Caches.new(self, get_root('caches'   )); end

  def    runner;    @runner ||= external_object; end
  def     katas;     @katas ||= external_object; end
  def     shell;     @shell ||= external_object; end
  def      disk;      @disk ||= external_object; end
  def       log;       @log ||= external_object; end
  def       git;       @git ||= external_object; end

  def get_root(name); ENV[env_root(name)] || fail_not_set(name, 'root'); end
  def env_root(name); env(name, 'root'); end

  def get_class(name); ENV[env_class(name)] || fail_not_set(name, 'class'); end
  def env_class(name); env(name, 'class'); end

  private

  include NameOfCaller

  def external_object
    key = name_of(caller)
    var = get_class(key)
    Object.const_get(var).new(self)
  end

  def env(name, suffix); 'CYBER_DOJO_' + name.upcase + '_' + suffix.upcase; end

  def fail_not_set(type, name)
    fail "ENV[#{env(type, name)}] not set"
  end

end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# External root-paths and class-names have defaults as set in config/cyber-dojo.json.
# Root-path and class-name defaults can be overridden by setting environment variables.
#   eg  export CYBER_DOJO_KATAS_ROOT=/var/www/cyber-dojo/katas
#   eg  export CYBER_DOJO_RUNNER_CLASS=DockerTmpRunner
#
# This is for testability. It's a way of doing Parameterize From Above
# in a way that can tunnel through a *deep* stack. For example,
# I can set an environment variable and then run a controller test,
# which issues GETs/POSTs, which work their way through the rails stack,
# eventually reaching app/models.dojo.rb (possibly in a different thread)
# where the specific Double/Mock/Stub class or fake-root-path takes effect.
#
# The external objects are held using
#    @name ||= ...
# I use ||= partly for optimization and partly for testing
# (where it is handy that it is the same object)
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
