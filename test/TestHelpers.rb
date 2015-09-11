gem "minitest"
require 'minitest/autorun'

module TestHelpers # mix-in

  def setup
    check_external_setup
    store_external_setup
  end

  def teardown
    restore_external_setup    
  end
    
  # - - - - - - - - - - - - - - - - - - -
  
  def set_languages_root(value); cd_set(languages_key,value); end
  def set_exercises_root(value); cd_set(exercises_key,value); end
  def set_katas_root(value);     cd_set(    katas_key,value); end
  
  def set_runner_class(value);   cd_set(  runner_key,value); end
  def set_disk_class(value);     cd_set(    disk_key,value); end
  def set_git_class(value);      cd_set(     git_key,value); end
  def set_one_self_class(value); cd_set(one_self_key,value); end
  
  # - - - - - - - - - - - - - - - - - - -
  
  def get_languages_root; cd_get(languages_key); end  
  def get_exercises_root; cd_get(exercises_key); end
  def get_katas_root;     cd_get(    katas_key); end  
  
  def get_runner_class;   cd_get(  runner_key); end
  def get_disk_class;     cd_get(    disk_key); end
  def get_git_class;      cd_get(     git_key); end
  def get_one_self_class; cd_get(one_self_key); end
    
  # - - - - - - - - - - - - - - - - - - -
  
  def dojo; @dojo ||= Dojo.new; end

  def languages; dojo.languages; end
  def exercises; dojo.exercises; end  
  def katas;     dojo.katas;     end  
  def disk;      dojo.disk;      end  
  def runner;    dojo.runner;    end
  def git;       dojo.git;       end
  def one_self;  dojo.one_self;  end

  # - - - - - - - - - - - - - - - - - - -
    
  def assert_not_nil(o)
    assert !o.nil?
  end

  def assert_not_equal(lhs,rhs)
    assert lhs != rhs
  end
    
  # - - - - - - - - - - - - - - - - - - -
    
  include UniqueId

  def make_kata(id = unique_id, language_name = 'C-assert', exercise_name = 'Fizz_Buzz')
    language = languages[language_name]
    exercise = exercises[exercise_name]
    katas.create_kata(language, exercise, id)
  end
        
  def stub_test(avatar,param)
    assert_equal 'RunnerStub', get_runner_class_name
    stub_test_colours(avatar,param) if param.class.name == 'Array'
    stub_test_n(avatar,param) if param.class.name == 'Fixnum'
  end
  
private
  
  def stub_test_colours(avatar,colours)
    root = File.expand_path(File.dirname(__FILE__)) + '/app_lib/test_output'    
    colours.each do |colour|    
      path = "#{root}/#{avatar.kata.language.unit_test_framework}/#{colour}"
      all_outputs = Dir.glob(path + '/*')      
      filename = all_outputs.shuffle[0]
      output = File.read(filename)
      dojo.runner.stub_output(output)      
      delta = { :changed => [], :new => [], :deleted => [] }
      files = { }
      rags,_,_ = avatar.test(delta,files)
      assert_equal colour, rags[-1]['colour'].to_sym
    end
  end

  def stub_test_n(avatar, n)
    colours = (1..n).collect { [:red,:amber,:green].shuffle[0] }
    stub_test_colours(avatar, colours)
  end
  
  # - - - - - - - - - - - - - - - - - - - - - - - - -
  
  def languages_key; root('LANGUAGES'); end
  def exercises_key; root('EXERCISES'); end
  def     katas_key; root(    'KATAS'); end   
  
  def root(key)
    cd(key + '_ROOT')
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - -

  def     disk_key; class_name('DISK'); end
  def   runner_key; class_name('RUNNER'); end
  def      git_key; class_name('GIT'); end
  def one_self_key; class_name('ONE_SELF'); end

  def class_name(key)
    cd(key + '_CLASS')
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - -

  def cd(key)
    'CYBER_DOJO_' + key
  end
  
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
    
  # - - - - - - - - - - - - - - - - - - - - - - - - -
    
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

  # - - - - - - - - - - - - - - - - - - - - - - - - -

  def cd_get(key)
    ENV[key]
  end       
  
  def cd_set(key,value)
    ENV[key] = value
  end
  
end
