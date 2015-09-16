
ENV['RAILS_ENV'] = 'test' # ????

gem 'minitest'
require 'minitest/autorun'

root = '../..'

require_relative root + '/test/test_coverage'
require_relative root + '/test/all'
require_relative root + '/config/environment'
require_relative root + '/test/TestDomainHelpers'
require_relative root + '/test/TestExternalHelpers'
require_relative root + '/test/TestHexIdHelpers'
  
class AppControllerTestBase < ActionDispatch::IntegrationTest

  include TestDomainHelpers
  include TestExternalHelpers
  include TestHexIdHelpers

  def setup
    super
    root = File.expand_path('../..', File.dirname(__FILE__)) 
    set_katas_root(root + '/tmp/katas')
    set_one_self_class('OneSelfDummy')
  end
  
  def create_kata(language_name = random_language, exercise_name = random_exercise)
    parts = language_name.split(',')
    params = { 
      :language => parts[0].strip,
      :test => parts[1].strip,
      :exercise => exercise_name
    }
    get 'setup/save', params
    @id = json['id']
  end
    
  def enter
    params = { :format => :json }
    params[:id] = @id if !@id.nil?
    get 'dojo/enter', params
    @avatar_name = avatar_name
  end
    
  def re_enter
    params = { :format => :json, :id => @id }
    get 'dojo/re_enter', params
    assert_response :success    
  end

  def kata_edit
    params = { :id => @id, :avatar => @avatar_name }
    get 'kata/edit', params
    assert_response :success
  end
    
  def kata_run_tests(file_hash)
    params = { :format => :js, :id => @id, :avatar => @avatar_name }
    post 'kata/run_tests', params.merge(file_hash)
  end

  def make_file_hash(filename,content,incoming,outgoing)
    { file_content:         { filename => content },
      file_hashes_incoming: { filename => incoming },
      file_hashes_outgoing: { filename => outgoing }
    }
  end
    
  def any_test
    filename = 'cyber-dojo.sh'
    kata_run_tests make_file_hash(filename,'',234234,-4545645678)
  end

  def stub_test_output(rag)
    # todo: refactor
    #       copied from test/TestHelpers.rb stub_test_colours (private)
    avatar = katas[@id].avatars[@avatar_name]
    disk = dojo.disk
    root = File.expand_path(File.dirname(__FILE__) + '/..') + '/app_lib/test_output'
    assert [:red,:amber,:green].include? rag
    path = "#{root}/#{avatar.kata.language.unit_test_framework}/#{rag}"
    all_outputs = disk[path].each_file.collect{|filename| filename}
    filename = all_outputs.shuffle[0]
    output = disk[path].read(filename)
    dojo.runner.stub_output(output)      
    delta = { :changed => [], :new => [], :deleted => [] }
    files = { }
    rags,_,_ = avatar.test(delta,files)
    assert_equal rag, rags[-1]['colour'].to_sym
  end
        
  def json
    ActiveSupport::JSON.decode @response.body
  end

  def html
    @response.body
  end
  
  def avatar_name
    json['avatar_name']
  end
  
private

  def random_language
    # languages.collect....
    # will cause TestRunner.runnable?() to be executed...
    # which means I can't later Stub a different TestRunner...
    'Ruby, TestUnit'  # todo
  end
  
  def random_exercise
    'Yatzy' # todo
  end
  
=begin
  def stub_setup
    stub_dojo
    stub_language('fake-C#','nunit')
    stub_exercise('fake-Yatzy')
    @id = create_kata('fake-C#','fake-Yatzy')
  end

  def stub_dojo
    reset_external(:disk, DiskFake.new)
    reset_external(:git, GitSpy.new)
    reset_external(:runner, TestRunnerStub.new)
    @dojo = Dojo.new
  end

  def stub_language(language_name, unit_test_framework)
    language = @dojo.languages[language_name]
    language.dir.write('manifest.json', 
      { 
        'unit_test_framework' => unit_test_framework,
        'display_name' => language_name.gsub('-',',')
      })
  end

  def stub_exercise(exercise_name)
    exercise = @dojo.exercises[exercise_name]
    exercise.dir.write('instructions', 'your task...')
  end

  def stub_kata(id, language_name, exercise_name)
    kata = @dojo.katas[id]
    kata.dir.write('manifest.json', { language:language_name,
                                      exercise:exercise_name })
  end

  def root_path
    File.absolute_path(File.dirname(__FILE__) + '/../../')
  end
=end
  
end
