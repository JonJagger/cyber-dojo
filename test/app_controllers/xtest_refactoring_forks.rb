#!/usr/bin/env ruby

require_relative 'controller_test_base'

class RefactoringForksControllerTest  < ControllerTestBase

  test 'refactor Python Tennis' do

    get 'forker/fork',
      :format => :json,
      :id => '435E5C1C88',
      :avatar => 'moose',
      :tag => '5'

    assert_not_nil json, 'assert_not_nil json'
    assert_equal true, json['forked'], json.inspect
    forked_kata_id = json['id']
    assert_not_nil forked_kata_id, json.inspect
    assert_equal 10, forked_kata_id.length
    assert_not_equal id, forked_kata_id
    forked_kata = @dojo.katas[forked_kata_id]
    assert forked_kata.exists?

    assert_equal 'Python, unitttest', forked_kata.language.name
    assert_equal 'Tennis', forked_kata.exercise.name

  end

end
