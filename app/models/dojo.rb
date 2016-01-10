# See cyber-dojo-model.pdf

class Dojo

  def root_dir
    File.expand_path('../..', File.dirname(__FILE__))  # /var/www/cyber-dojo
  end

  def config_filename
    root_dir + '/config/cyber-dojo.json'
  end

  def config
    @config ||= JSON.parse(IO.read(config_filename))
  end

  def languages; @languages ||= Languages.new(self); end
  def exercises; @exercises ||= Exercises.new(self); end
  def    caches; @caches    ||=    Caches.new(self); end

  def    runner;    @runner ||= external_object; end
  def     katas;     @katas ||= external_object; end
  def     shell;     @shell ||= external_object; end
  def      disk;      @disk ||= external_object; end
  def       log;       @log ||= external_object; end
  def       git;       @git ||= external_object; end

  private

  include NameOfCaller

  def external_object
    key = name_of(caller)
    var = config['class'][key]
    Object.const_get(var).new(self)
  end

end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# External paths can be set via the config file.
# External objects can be set via the config file.
#
# The main reason for this arrangement is testability.
# For example, I can run controller tests by setting the
# config, then run the test which issue a GET/POST,
# let the call work its way through the rails stack,
# eventually reaching dojo.rb where it creates
# Disk/Runner/Git/Shell/etc objects as named in the config.
#
# The external objects are held using
#    @name ||= ...
# I use ||= partly for optimization and partly for testing
# (where it is handy that it is the same object)
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
