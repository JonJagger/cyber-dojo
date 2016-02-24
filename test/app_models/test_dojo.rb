#!/bin/bash ../test_wrapper.sh

require_relative './app_models_test_base'

class ExternalDouble
  def initialize(_dojo, _path = nil)
  end
end

class DojoTests < AppModelsTestBase

  #- - - - - - - - - - - - - - - - - - - - - - - - -
  # no defaults
  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test 'AACE2A',
  'external classes have no default' do
    unset_runner_class && assert_raises(StandardError) { runner.class }
    unset_katas_class  && assert_raises(StandardError) {  katas.class }
    unset_shell_class  && assert_raises(StandardError) {  shell.class }
    unset_disk_class   && assert_raises(StandardError) {   disk.class }
    unset_git_class    && assert_raises(StandardError) {    git.class }
    unset_log_class    && assert_raises(StandardError) {    log.class }
  end

  test '62C6F9',
  'external root directories have no default' do
    unset_exercises_root && assert_raises(StandardError) { exercises.class }
    unset_languages_root && assert_raises(StandardError) { languages.class }
    unset_katas_root     && assert_raises(StandardError) {     katas.class }
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -
  # external classes
  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test 'D51880',
  'external classes can be set to existing classes' do
    set_runner_class('ExternalDouble') && assert_equal(ExternalDouble, runner.class)
    set_katas_class( 'ExternalDouble') && assert_equal(ExternalDouble,  katas.class)
    set_shell_class( 'ExternalDouble') && assert_equal(ExternalDouble,  shell.class)
    set_disk_class(  'ExternalDouble') && assert_equal(ExternalDouble,   disk.class)
    set_git_class(   'ExternalDouble') && assert_equal(ExternalDouble,    git.class)
    set_log_class(   'ExternalDouble') && assert_equal(ExternalDouble,    log.class)
  end

  test 'B0E7E4',
  'external classes cannot be set to non-existing classes' do
    set_runner_class(does_not_exist) && assert_raises(StandardError) { runner.class }
    set_katas_class( does_not_exist) && assert_raises(StandardError) {  katas.class }
    set_shell_class( does_not_exist) && assert_raises(StandardError) {  shell.class }
    set_disk_class(  does_not_exist) && assert_raises(StandardError) {   disk.class }
    set_git_class(   does_not_exist) && assert_raises(StandardError) {    git.class }
    set_log_class(   does_not_exist) && assert_raises(StandardError) {    log.class }
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -
  # external roots
  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test '209EA1',
  'external roots can be set' do
    set_exercises_root(path = tmp_root + 'exercises/') && assert_equal(path, exercises.path)
    set_languages_root(path = tmp_root + 'languages/') && assert_equal(path, languages.path)
    set_katas_root(    path = tmp_root + 'katas/'    ) && assert_equal(path, katas.path)
  end

  # - - - - - -

  test '01CD52',
  'external roots always have trailing slash even when set value does not' do
    set_exercises_root(path = tmp_root + '/exercises') && assert_equal(path + '/', exercises.path)
    set_languages_root(path = tmp_root + '/languages') && assert_equal(path + '/', languages.path)
    set_katas_root(    path = tmp_root + '/katas')     && assert_equal(path + '/', katas.path)
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  test 'CBFF2D',
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
