
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
    raise "setup already called" if !@original_config.nil?
    @original_config = read_config
    setup_tmp_root
    # we never want tests to write to the real katas root
    set_katas_root(tmp_root + 'katas')
  end

  def teardown
    fail_if_setup_not_called('teardown')
    IO.write(config_filename, @original_config)
    @original_config = nil
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
    config = read_json_config
    config['root'][name] = value
    IO.write(config_filename, JSON.unparse(config))
    `mkdir -p #{value}` if name == 'katas'
    `mkdir -p #{value}` if name == 'caches'
  end

  def set_class(name, value)
    fail_if_setup_not_called("set_class(#{name}, #{value})")
    config = read_json_config
    config['class'][name] = value
    IO.write(config_filename, JSON.unparse(config))
  end

  def get_root(name)
    read_json_config['root'][name]
  end

  def get_class(name)
    read_json_config['class'][name]
  end

  # - - - - - - - - - - - - - - - - - - -

  def read_json_config
    JSON.parse(read_config)
  end

  def read_config
    IO.read(config_filename)
  end

  def config_filename
    dojo.config_filename
  end

  def fail_if_setup_not_called(at)
    fail "#{at} NOT executed because store_config() not yet called" if @original_config.nil?
  end

end
