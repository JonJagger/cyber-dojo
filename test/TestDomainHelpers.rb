
module TestDomainHelpers # mix-in

  module_function

  include UniqueId

  def dojo; @dojo ||= Dojo.new; end

  def languages; dojo.languages; end
  def exercises; dojo.exercises; end  
  def katas;     dojo.katas;     end  
  def disk;      dojo.disk;      end  
  def runner;    dojo.runner;    end
  def git;       dojo.git;       end
  def one_self;  dojo.one_self;  end

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
  
end
