
module TestExternalHelpers # mix-in

  module_function

  # The config has to actually be written to the file system
  # because controller tests go through the rails stack and
  # thus create a new dojo object in a new thread.
  #
  # Calling setup twice in a row without an intervening teardown
  # is bad because an intervening set_katas_root() call (say)
  # means the second setup will read the overwritten config
  # so the final teardown will restore the overwritten config! Oops.

  def setup
    raise "setup already called" unless @setup_called.nil?
    @setup_called = true
    @config = {}
    ENV.each { |key,value| @config[key] = value }
    setup_tmp_root
    # we never want tests to write to the real katas root
    set_katas_root(tmp_root + 'katas')
  end

  def teardown
    fail_if_setup_not_called('teardown')
    # in ENV and not in config means it was set with no previous value -> delete
    (ENV.keys - @config.keys).each { |key| ENV.delete(key) }
    # in ENV and     in config means it was set with  a previous value -> reset
    (ENV.keys + @config.keys).each { |key| ENV[key] = @config[key] }
    @setup_called = nil
  end

  # - - - - - - - - - - - - - - - - - - -

  def set_languages_root(value); set_root('languages', value); end
  def set_exercises_root(value); set_root('exercises', value); end
  def    set_caches_root(value); set_root(   'caches', value); end
  def     set_katas_root(value); set_root(    'katas', value); end

  def   set_runner_class(value); set_class(   'runner', value); end
  def    set_katas_class(value); set_class(    'katas', value); end
  def    set_shell_class(value); set_class(    'shell', value); end
  def     set_disk_class(value); set_class(     'disk', value); end
  def      set_git_class(value); set_class(      'git', value); end
  def      set_log_class(value); set_class(      'log', value); end

  # - - - - - - - - - - - - - - - - - - -

  def get_languages_root; get_root('languages'); end
  def get_exercises_root; get_root('exercises'); end
  def    get_caches_root; get_root(   'caches'); end
  def     get_katas_root; get_root(    'katas'); end

  def   get_runner_class; get_class('runner'); end
  def    get_katas_class; get_class( 'katas'); end
  def    get_shell_class; get_class( 'shell'); end
  def     get_disk_class; get_class(  'disk'); end
  def      get_git_class; get_class(   'git'); end
  def      get_log_class; get_class(   'log'); end

  # - - - - - - - - - - - - - - - - - - -

  def set_root(name, value)
    fail_if_setup_not_called("set_root(#{name}, #{value})")
    ENV['CYBER_DOJO_'+name.upcase+'_ROOT'] = value
    `mkdir -p #{value}`
  end

  def set_class(name, value)
    fail_if_setup_not_called("set_class(#{name}, #{value})")
    ENV['CYBER_DOJO_'+name.upcase+'_CLASS'] = value
  end

  def get_root(name)
    dojo.get_root(name)
  end

  def get_class(name)
    dojo.get_class(name)
  end

  # - - - - - - - - - - - - - - - - - - -

  def fail_if_setup_not_called(cmd)
    fail "#{cmd} NOT executed because setup() not yet called" if @setup_called.nil?
  end

end
