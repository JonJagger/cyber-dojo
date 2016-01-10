
# env vars can be set before running a test
# if they are not set they get their defaults
# at the end of each test the env vars are restored.

module TestExternalHelpers # mix-in

  module_function

  # The config has to actually be written to because the controller
  # tests go through the rails stack and thus create a new dojo
  # object in a new thread.
  #
  # Calling setup twice in a row without an intervening teardown
  # is very bad because an intervening set_katas_root() call (say)
  # means the second setup will read the overwritten config
  # so the final teardown will restore the overwritten config! Oops.

  def setup
    raise "setup already called" if !@original_config.nil?
    @original_config = read_config
    setup_tmp_root
    set_katas_root(tmp_root + 'katas')
  end

  def teardown
    fail_if_setup_not_called('teardown')
    IO.write(config_filename, @original_config)
    @original_config = nil
  end

  # - - - - - - - - - - - - - - - - - - -

  def set_languages_root(value); root_set('languages', value); end
  def set_exercises_root(value); root_set('exercises', value); end
  def    set_caches_root(value); root_set(   'caches', value); end
  def     set_katas_root(value); root_set(    'katas', value); end

  def   set_runner_class(value); class_set(   'runner', value); end
  def    set_shell_class(value); class_set(    'shell', value); end
  def     set_disk_class(value); class_set(     'disk', value); end
  def      set_git_class(value); class_set(      'git', value); end
  def      set_log_class(value); class_set(      'log', value); end

  # - - - - - - - - - - - - - - - - - - -

  def get_languages_root; root_get('languages'); end
  def get_exercises_root; root_get('exercises'); end
  def    get_caches_root; root_get(   'caches'); end
  def     get_katas_root; root_get(    'katas'); end

  def   get_runner_class; class_get('runner'); end
  def    get_shell_class; class_get( 'shell'); end
  def     get_disk_class; class_get(  'disk'); end
  def      get_git_class; class_get(   'git'); end
  def      get_log_class; class_get(   'log'); end

  # - - - - - - - - - - - - - - - - - - -

  def root_set(name, value)
    fail_if_setup_not_called("root_set(#{name}, #{value})")
    config = read_json_config
    config['root'][name] = value
    IO.write(config_filename, JSON.unparse(config))
    `mkdir -p #{value}` if name == 'katas'
    #TODO: what about caches?
  end

  def class_set(name, value)
    fail_if_setup_not_called("class_set(#{name}, #{value})")
    config = read_json_config
    config['class'][name] = value
    IO.write(config_filename, JSON.unparse(config))
  end

  def root_get(name)
    read_json_config['root'][name]
  end

  def class_get(name)
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
