
ENV['RAILS_ENV'] = 'test'

require_relative './../../test/all'
require_relative './../../config/environment'
require_relative './params_maker'

class AppControllerTestBase < ActionDispatch::IntegrationTest

  include TestDomainHelpers
  include TestExternalHelpers
  include TestHexIdHelpers

  def setup
    super
    set_runner_class('StubRunner')
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def create_kata(language_name = default_language, exercise_name = default_exercise)
    parts = language_name.split(',')
    params = {
      language: parts[0].strip,
          test: parts[1].strip,
      exercise: exercise_name
    }
    get 'setup/save', params
    @id = json['id']
  end

  def start
    params = { :format => :json, :id => @id }
    get 'enter/start', params
    assert_response :success
    avatar_name = json['avatar_name']
    assert_not_nil avatar_name
    @avatar = katas[@id].avatars[avatar_name]
    @params_maker = ParamsMaker.new(@avatar)
    @avatar
  end

  def start_full
    params = { :format => :json, :id => @id }
    get 'enter/start', params
    assert_response :success
  end

  def continue
    params = { :format => :json, :id => @id }
    get 'enter/continue', params
    assert_response :success
  end

  def kata_edit
    params = { :id => @id, :avatar => @avatar.name }
    get 'kata/edit', params
    assert_response :success
  end

  def content(filename)
    @params_maker.content(filename)
  end

  def change_file(filename, content)
    @params_maker.change_file(filename, content)
  end

  def delete_file(filename)
    @params_maker.delete_file(filename)
  end

  def new_file(filename, content)
    @params_maker.new_file(filename, content)
  end

  def run_tests
    params = { :format => :js, :id => @id, :avatar => @avatar.name }
    post 'kata/run_tests', params.merge(@params_maker.params)
    @params_maker = ParamsMaker.new(@avatar)
    assert_response :success
  end

  def hit_test
    run_tests
  end

  def json
    ActiveSupport::JSON.decode html
  end

  def html
    @response.body
  end

  private

  def default_language
    'Ruby, TestUnit'
  end

  def default_exercise
    'Yatzy'
  end

end

