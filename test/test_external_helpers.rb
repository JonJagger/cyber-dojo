
# env vars can be set before running a test
# if they are not set they get their defaults
# at the end of each test the env vars are restored.

module TestExternalHelpers # mix-in

  module_function

  def setup
    store_env_vars
    setup_tmp_root
    set_katas_root(tmp_root + 'katas')
  end

  def teardown; restore_env_vars; end

  # - - - - - - - - - - - - - - - - - - -

  def set_languages_root(value); cd_root_set('languages', value); end
  def set_exercises_root(value); cd_root_set('exercises', value); end
  def    set_caches_root(value); cd_root_set(   'caches', value); end
  def     set_katas_root(value); cd_root_set(    'katas', value); end

  def cd_root_set(name, value)
    #p "cd_root_set(#{name}), #{value}"
    config = read_config
    config['root'][name] = value
    IO.write(config_filename, JSON.unparse(config))
  end

  def get_languages_root; cd_root_get('languages'); end
  def get_exercises_root; cd_root_get('exercises'); end
  def    get_caches_root; cd_root_get(   'caches'); end
  def     get_katas_root; cd_root_get(    'katas'); end

  def cd_root_get(name)
    got = read_config['root'][name]
    #p "cd_root_get(#{name}) = #{got}"
    got
  end

  # - - - - - - - - - - - - - - - - - - -

  def   set_runner_class(value); cd_set(   runner_key, value); end
  def    set_shell_class(value); cd_set(    shell_key, value); end
  def     set_disk_class(value); cd_set(     disk_key, value); end
  def      set_git_class(value); cd_set(      git_key, value); end
  def      set_log_class(value); cd_set(      log_key, value); end

  def   get_runner_class; cd_get(   runner_key); end
  def    get_shell_class; cd_get(    shell_key); end
  def     get_disk_class; cd_get(     disk_key); end
  def      get_git_class; cd_get(      git_key); end
  def      get_log_class; cd_get(      log_key); end

  # - - - - - - - - - - - - - - - - - - -

  def read_config
    JSON.parse(IO.read(config_filename))
  end

  def config_filename
    File.expand_path('../config', File.dirname(__FILE__)) + '/cyber-dojo.json'
  end

  def store_env_vars
    @original_config = read_config

    @store_env_vars_called = true
    @exported = {}
    @unset = []
    env_vars.each do |var, default|
      if ENV[var].nil?
        @unset << var
      else
        @exported[var] = ENV[var]
      end
    end
  end

  def restore_env_vars
    fail "store_env_vars() not called" if @store_env_vars_called.nil?
    IO.write(config_filename, JSON.unparse(@original_config))

    @exported.each { |var, value| ENV[var] = @exported[var] }
    @exported = {}
    @unset.each { |var| cd_unset(var) }
    @unset = []
  end

  def env_vars
    root_dir = File.expand_path('..', File.dirname(__FILE__))
    {
      languages_key => root_dir + '/languages',
      exercises_key => root_dir + '/exercises',
      katas_key     => root_dir + '/katas',
      caches_key    => root_dir + '/caches',

      runner_key    => 'DockerRunner',
      shell_key     => 'HostShell',
      disk_key      => 'HostDisk',
      git_key       => 'HostGit',
      log_key       => 'HostLog',
    }
  end

  def languages_key; root('LANGUAGES'); end
  def exercises_key; root('EXERCISES'); end
  def     katas_key; root(    'KATAS'); end
  def    caches_key; root(   'CACHES'); end

  def    runner_key; klass('RUNNER'  ); end
  def     shell_key; klass('SHELL'   ); end
  def      disk_key; klass('DISK'    ); end
  def       git_key; klass('GIT'     ); end
  def       log_key; klass('LOG'     ); end

  def root (key); cd(key + '_ROOT' ); end
  def klass(key); cd(key + '_CLASS'); end

  def cd_unset(key); ENV.delete(key); end
  def cd_set(key, value); ENV[key] = value; end
  def cd_get(key); ENV[key] || env_vars[key]; end
  def cd(key); 'CYBER_DOJO_' + key; end

end
