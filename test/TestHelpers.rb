require 'minitest/autorun'

module TestHelpers # mixin

  def setup
    check_test_environment_setup    
  end

  def teardown
    restore_original_test_environment    
  end

  # - - - - - - - - - - - - - - - - - - -

  def dojo; @dojo ||= Dojo.new; end  
  def languages; dojo.languages; end
  def exercises; dojo.exercises; end
  def katas; dojo.katas; end
  def disk; dojo.disk; end
  def runner; dojo.runner; end

  # - - - - - - - - - - - - - - - - - - -

  def languages_root; cd_get(languages_key); end
  def set_languages_root(value); cd_set(languages_key,value); end
  
  def exercises_root; cd_get(exercises_key); end
  def set_exercises_root(value); cd_set(exercises_key,value); end

  def katas_root; cd_get(katas_key); end
  def set_katas_root(value); cd_set(katas_key,value); end
  
  def runner_class_name; cd_get(runner_key); end  
  def set_runner_class_name(value); cd_set(runner_key,value); end  

  def disk_class_name; cd_get(disk_key); end  
  def set_disk_class_name(value); cd_set(disk_key,value); end
  
  def git_class_name; cd_get(git_key); end
  def set_git_class_name(value); cd_set(git_key,value); end
    
  # - - - - - - - - - - - - - - - - - - -
    
  def assert_not_nil(o)
    assert !o.nil?
  end

  def assert_not_equal(lhs,rhs)
    assert lhs != rhs
  end
    
  # - - - - - - - - - - - - - - - - - - -
    
  def make_kata(id = unique_id, language_name = 'C-assert', exercise_name = 'Fizz_Buzz')
    language = languages[language_name]
    exercise = exercises[exercise_name]
    katas.create_kata(language, exercise, id)
  end
        
  def stub_test(avatar,param)
    stub_test_colours(avatar,param) if param.class.name == 'Array'
    stub_test_n(avatar,param) if param.class.name == 'Fixnum'
  end
  
private
  
  def stub_test_colours(avatar,colours)
    disk = dojo.disk
    root = File.expand_path(File.dirname(__FILE__)) + '/app_lib/test_output'    
    colours.each do |colour|    
      path = "#{root}/#{avatar.kata.language.unit_test_framework}/#{colour}"
      all_outputs = disk[path].each_file.collect{|filename| filename}
      filename = all_outputs.shuffle[0]
      output = disk[path].read(filename)
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
  
  def languages_key; 'LANGUAGES_ROOT'; end
  def exercises_key; 'EXERCISES_ROOT'; end
  def katas_key; 'KATAS_ROOT'; end
  def disk_key; 'DISK'; end
  def runner_key; 'RUNNER'; end
  def git_key; 'GIT'; end
    
  def env_vars
    [languages_key,exercises_key,katas_key,disk_key,runner_key,git_key]
  end
  
  def check_test_environment_setup
    env_vars.each { |var| store(var) }
  end
  
  def restore_original_test_environment    
    env_vars.each { |var| restore(var) }
  end
   
  def store(key)
    raise RuntimeError.new("ENV['#{cd(key)}'] not set") if ENV[cd(key)].nil?
    @test_env ||= { }       
    @test_env[cd(key)] = cd_get(key)    
  end
  
  def restore(key)
    ENV[cd(key)] = @test_env[cd(key)]
  end
  
  def cd(name)
    name = name + '_CLASS_NAME' if !name.end_with? '_ROOT'
    'CYBER_DOJO_' + name
  end

  def cd_set(key,value)
    ENV[cd(key)] = value
  end

  def cd_get(key)
    ENV[cd(key)]
  end       
  
end