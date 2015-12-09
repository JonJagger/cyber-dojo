#!/usr/bin/env ruby

root = '../..'
require_relative root + '/config/environment.rb'

require_relative root + '/lib/DummyTestRunner'
require_relative root + '/lib/Git'
require_relative root + '/lib/HostDisk'

class RefactoringForksControllerTest  < ActionController::IntegrationTest

  test 'refactor Python Tennis' do

    externals = {
      :runner => DummyTestRunner.new,
      :disk   => OsDisk.new,
      :git    => Git.new
    }

    root_path = '/Users/jonjagger/Desktop/Repos/cyberdojo/'
    @dojo = Dojo.new(root_path,externals)

    id = '435E5C1C88'
    get 'forker/fork',
      :format => :json,
      :id => id,
      :avatar => 'moose',
      :tag => '5'

    refute_nil json, 'assert_not_nil json'
    assert_equal true, json['forked'], json.inspect
    forked_kata_id = json['id']

    puts forked_kata_id

    refute_nil forked_kata_id, json.inspect
    assert_equal 10, forked_kata_id.length
    refute_equal id, forked_kata_id
    forked_kata = @dojo.katas[forked_kata_id]
    assert forked_kata.exists?, 'forked_kata.exists?'

    assert_equal 'Python-unittest', forked_kata.language.name
    assert_equal 'Tennis', forked_kata.exercise.name

  end

  def json
    ActiveSupport::JSON.decode @response.body
  end

end
