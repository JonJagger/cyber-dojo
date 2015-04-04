require 'minitest/autorun'

class TestBase < MiniTest::Test

  def setup
    check_test_environment_setup    
  end
  
  def teardown
    restore_original_test_environment    
  end
  
  def self.test(name, &block)
    define_method("test_#{name}".to_sym, &block)
  end

  def assert_not_nil(o)
    assert !o.nil?
  end

  def assert_not_equal(lhs,rhs)
    assert lhs != rhs
  end

  def languages_root; get('LANGUAGES_ROOT'); end
  def set_languages_root(value); set('LANGUAGES_ROOT',value); end
  
  def exercises_root; get('EXERCISES_ROOT'); end
  def set_exercises_root(value); set('EXERCISES_ROOT',value); end

  def katas_root; get('KATAS_ROOT'); end
  def set_katas_root(value); set('KATAS_ROOT',value); end
  
  def runner_class_name; get('RUNNER_CLASS_NAME'); end  
  def set_runner_class_name(value); set('RUNNER_CLASS_NAME',value); end  

  def disk_class_name; get('DISK_CLASS_NAME'); end
  def set_disk_class_name(value); set('DISK_CLASS_NAME',value); end
  
  def git_class_name; get('GIT_CLASS_NAME'); end
  def set_git_class_name(value); set('GIT_CLASS_NAME',value); end
    
private
  
  def check_test_environment_setup
    store('EXERCISES_ROOT')
    store('LANGUAGES_ROOT')
    store('KATAS_ROOT')
    store('DISK_CLASS_NAME')
    store('RUNNER_CLASS_NAME')
    store('GIT_CLASS_NAME')    
  end
  
  def restore_original_test_environment    
    restore('EXERCISES_ROOT')
    restore('LANGUAGES_ROOT')
    restore('KATAS_ROOT')
    restore('DISK_CLASS_NAME')
    restore('RUNNER_CLASS_NAME')
    restore('GIT_CLASS_NAME')
  end
  
  def store(key)
    raise RuntimeError.new("ENV['#{cd(key)}'] not set") if ENV[cd(key)].nil?
    @test_env ||= { }        
    @test_env[cd(key)] = get(key)    
  end
  
  def restore(key)
    ENV[cd(key)] = @test_env[cd(key)]
  end

  def get(key)  
    ENV[cd(key)]
  end
  
  def set(key,value)
    ENV[cd(key)] = value
  end
  
  def cd(name)
    'CYBER_DOJO_' + name
  end

end