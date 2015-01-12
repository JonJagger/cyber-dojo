#!/usr/bin/env ruby

require_relative 'model_test_base'

class LanguagesTests < ModelTestBase

  test 'path is set from :languages_path' do
    reset_external(:languages_path, 'end_with_slash/')
    assert_equal 'end_with_slash/', Languages.new.path
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'path appends slash if necessary' do
    reset_external(:languages_path, 'languages')
    assert_equal 'languages/', Languages.new.path
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'dojo.languages.each() empty' do
    stub_exists(expected = [ ])
    assert_equal expected, languages.each.map {|language| language.name}
  end

  #- - - - - - - - - - - - - - - - - - - - -

  test 'dojo.languages.each() not empty' do
    stub_exists(expected = ['C#-NUnit','Ruby-TestUnit'])
    assert_equal expected, languages.each.map {|language| language.name}.sort
  end

  #- - - - - - - - - - - - - - - - - - - - -

  test 'dojo.languages[name] returns language with given name' do
    ['Ruby-Cucumber','C#-NUnit'].each do |name|
      assert_equal name, languages[name].name
    end
  end

  #- - - - - - - - - - - - - - - - - - - - -

  def languages
    @dojo.languages
  end

  def stub_exists(languages_names)
    languages_names.each do |name|
      language = languages[name]
      language.dir.write('manifest.json', {})
    end
  end

end
