#!/usr/bin/env ruby

require_relative 'model_test_base'

class DojoTests < ModelTestBase

  test 'exercises property' do
    reset_external(:exercises_path, 'fake_exercises_path/')
    assert_equal "Exercises", Dojo.new.exercises.class.name
  end

  test 'languages property' do
    reset_external(:languages_path, 'fake_languages_path/')
    assert_equal "Languages", Dojo.new.languages.class.name
  end

  test 'katas property' do
    reset_external(:katas_path, 'fake_katas_path/')
    assert_equal "Katas", Dojo.new.katas.class.name
  end

end
