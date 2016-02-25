#!/bin/bash ../test_wrapper.sh

require_relative './app_models_test_base'

class ExternalDouble
  def initialize(_dojo, _path = nil)
  end
end

class DojoTest < AppModelsTestBase

  prefix = 'FB7'

  #- - - - - - - - - - - - - - - - - - - - - - - - -
  # external classes and roots have no defaults
  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test prefix+'E2A',
  'using an unset external class raises StandardError' do
    unset_runner_class && assert_raises(StandardError) { runner.class }
    unset_katas_class  && assert_raises(StandardError) {  katas.class }
    unset_shell_class  && assert_raises(StandardError) {  shell.class }
    unset_disk_class   && assert_raises(StandardError) {   disk.class }
    unset_git_class    && assert_raises(StandardError) {    git.class }
    unset_log_class    && assert_raises(StandardError) {    log.class }
  end

  test prefix+'6F9',
  'using an unset external root raises StandardError' do
    unset_exercises_root && assert_raises(StandardError) { exercises.class }
    unset_languages_root && assert_raises(StandardError) { languages.class }
    unset_katas_root     && assert_raises(StandardError) {     katas.class }
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -
  # external classes can be set via environment variables
  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test prefix+'880',
  'setting an external class to the name of an existing class succeeds' do
    exists = 'ExternalDouble'
    set_runner_class(exists) && assert_equal(exists, runner.class.name)
    set_katas_class( exists) && assert_equal(exists,  katas.class.name)
    set_shell_class( exists) && assert_equal(exists,  shell.class.name)
    set_disk_class(  exists) && assert_equal(exists,   disk.class.name)
    set_git_class(   exists) && assert_equal(exists,    git.class.name)
    set_log_class(   exists) && assert_equal(exists,    log.class.name)
  end

  test prefix+'7E4',
  'setting an external class to the name of a non-existant class raises StandardError' do
    set_runner_class(does_not_exist) && assert_raises(StandardError) { runner.class }
    set_katas_class( does_not_exist) && assert_raises(StandardError) {  katas.class }
    set_shell_class( does_not_exist) && assert_raises(StandardError) {  shell.class }
    set_disk_class(  does_not_exist) && assert_raises(StandardError) {   disk.class }
    set_git_class(   does_not_exist) && assert_raises(StandardError) {    git.class }
    set_log_class(   does_not_exist) && assert_raises(StandardError) {    log.class }
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -
  # external roots can be set via environment variables
  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test prefix+'EA1',
  'setting an external root succeeds' do
    set_exercises_root(path = tmp_root + '/exercises') && assert_equal(path, exercises.path)
    set_languages_root(path = tmp_root + '/languages') && assert_equal(path, languages.path)
    set_katas_root(    path = tmp_root + '/katas'    ) && assert_equal(path, katas.path)
  end

  # - - - - - -

  test prefix+'D52',
  'setting an external root with a trailing slash chops off the trailing slash' do
    path = tmp_root + '/exercises'
    set_exercises_root(path + '/') && assert_equal(path, exercises.path)
    path = tmp_root + '/languages'
    set_languages_root(path + '/') && assert_equal(path, languages.path)
    path = tmp_root + '/katas'
    set_katas_root(path + '/')     && assert_equal(path, katas.path)
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  test prefix+'F2D',
  'katas.path is set off /tmp by test setup because tests write to katas' do
    test_set_path = dojo.env('katas', 'root')
    assert test_set_path.include?('/tmp')
    assert katas.path.include?('/tmp')
  end

  private

  def does_not_exist
    'DoesNotExist'
  end

end
