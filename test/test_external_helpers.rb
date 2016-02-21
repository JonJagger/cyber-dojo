
module TestExternalHelpers # mix-in

  module_function

  def setup
    raise "setup already called" unless @setup_called.nil?
    @setup_called = true
    @config = {}
    ENV.each { |key,value| @config[key] = value }
    setup_tmp_root
    # we never want tests to write to the real katas root
    set_katas_root(tmp_root + 'katas')
    # wipe caches, but not via caches.path because that will *set* dojo.caches!
    `rm -rf #{get_caches_root}/exercises_cache.json`
    `rm -rf #{get_caches_root}/languages_cache.json`
    `rm -rf #{get_caches_root}/runner_cache.json`
  end

  def teardown
    fail_if_setup_not_called('teardown')
    # set and no previous value -> unset
    (ENV.keys - @config.keys).each { |key| unset(key) }
    # set but has previous value -> restore
    (ENV.keys + @config.keys).each { |key| ENV[key] = @config[key] }
    @setup_called = nil
  end

  # - - - - - - - - - - - - - - - - - - -

  def unset_languages_root; unset(dojo.env_name('languages', 'root')); end
  def unset_exercises_root; unset(dojo.env_name('exercises', 'root')); end
  def    unset_caches_root; unset(dojo.env_name('caches',    'root')); end
  def     unset_katas_root; unset(dojo.env_name('katas',     'root')); end

  def unset_runner_class; unset(dojo.env_name('runner', 'class')); end
  def  unset_katas_class; unset(dojo.env_name('katas',  'class')); end
  def  unset_shell_class; unset(dojo.env_name('shell',  'class')); end
  def   unset_disk_class; unset(dojo.env_name('disk',   'class')); end
  def    unset_git_class; unset(dojo.env_name('git',    'class')); end
  def    unset_log_class; unset(dojo.env_name('log',    'class')); end

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

  def get_languages_root; dojo.fenv('languages', 'root'); end
  def get_exercises_root; dojo.fenv('exercises', 'root'); end
  def    get_caches_root; dojo.fenv('caches',    'root'); end
  def     get_katas_root; dojo.fenv('katas',     'root'); end

  def   get_runner_class; dojo.fenv('runner', 'class'); end
  def    get_katas_class; dojo.fenv('katas',  'class'); end
  def    get_shell_class; dojo.fenv('shell',  'class'); end
  def     get_disk_class; dojo.fenv('disk',   'class'); end
  def      get_git_class; dojo.fenv('git',    'class'); end
  def      get_log_class; dojo.fenv('log',    'class'); end

  # - - - - - - - - - - - - - - - - - - -

  def unset(var); ENV.delete(var); end

  def set_root(key, value)
    fail_if_setup_not_called("set_root(#{key}, #{value})")
    ENV[dojo.env_name(key, 'root')] = value
    `mkdir -p #{value}`
  end

  def set_class(key, value)
    fail_if_setup_not_called("set_class(#{key}, #{value})")
    ENV[dojo.env_name(key, 'class')] = value
  end

  # - - - - - - - - - - - - - - - - - - -

  def tmp_root
    '/tmp/cyber-dojo/'
  end

  def setup_tmp_root
    # the Teardown-Before-Setup pattern gives good diagnostic info if
    # a test fails but these backtick command mean the tests cannot be
    # run in parallel...
    success = 0

    command = "rm -rf #{tmp_root}"
    output = `#{command}`
    exit_status = $?.exitstatus
    puts "#{command}\n\t->#{output}\n\t->#{exit_status}" unless exit_status == success

    command = "mkdir -p #{tmp_root}"
    output = `#{command}`
    exit_status = $?.exitstatus
    puts "#{command}\n\t->#{output}\n\t->#{exit_status}" unless exit_status == success
  end

  # - - - - - - - - - - - - - - - - - - -

  def fail_if_setup_not_called(cmd)
    fail "#{cmd} NOT executed because setup() not yet called" if @setup_called.nil?
  end

end
