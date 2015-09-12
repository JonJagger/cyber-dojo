
module TestExternalHelpers # mix-in
  
  module_function

  def setup
    check_external_setup
    store_external_setup
  end

  def teardown
    restore_external_setup    
  end

  # - - - - - - - - - - - - - - - - - - -

  def check_external_setup
    env_vars.each do |var|
      raise RuntimeError.new("ENV['#{var}'] not set") if ENV[var].nil?
    end
  end
  
  def store_external_setup
    @test_env = {}       
    env_vars.each { |var| @test_env[var] = ENV[var] }
  end

  def restore_external_setup
    raise "store_external_setup not called" if @test_env.nil?
    env_vars.each { |var| ENV[var] = @test_env[var] }
    @test_env = {}    
  end

  # - - - - - - - - - - - - - - - - - - -

  def set_languages_root(value); cd_set(languages_key,value); end
  def set_exercises_root(value); cd_set(exercises_key,value); end
  def set_katas_root(value);     cd_set(    katas_key,value); end
  def set_runner_class(value);   cd_set(   runner_key,value); end
  def set_disk_class(value);     cd_set(     disk_key,value); end
  def set_git_class(value);      cd_set(      git_key,value); end
  def set_one_self_class(value); cd_set( one_self_key,value); end

  # - - - - - - - - - - - - - - - - - - -

  def get_languages_root; cd_get(languages_key); end
  def get_exercises_root; cd_get(exercises_key); end
  def get_katas_root;     cd_get(    katas_key); end
  def get_runner_class;   cd_get(   runner_key); end
  def get_disk_class;     cd_get(     disk_key); end
  def get_git_class;      cd_get(      git_key); end
  def get_one_self_class; cd_get( one_self_key); end

  # - - - - - - - - - - - - - - - - - - -

  def env_vars
    [
      languages_key,
      exercises_key,
      katas_key,
      disk_key,
      runner_key,
      git_key,
      one_self_key
    ]
  end

  def languages_key; root('LANGUAGES'); end
  def exercises_key; root('EXERCISES'); end
  def     katas_key; root(    'KATAS'); end   
  
  def     disk_key; class_name('DISK'); end
  def   runner_key; class_name('RUNNER'); end
  def      git_key; class_name('GIT'); end
  def one_self_key; class_name('ONE_SELF'); end

  def root(key); cd(key + '_ROOT'); end
  def class_name(key); cd(key + '_CLASS'); end

  # - - - - - - - - - - - - - - - - - - -
  
  def cd_set(key,value); ENV[key] = value; end
  def cd_get(key); ENV[key]; end
  def cd(key); 'CYBER_DOJO_' + key; end

end
