#!/bin/bash ../test_wrapper.sh

require_relative './app_model_test_base'

class ExternalDouble
  def initialize(_dojo)
  end
end

class DojoTests < AppModelTestBase

  test '209EA1',
  'exercises' do
    path = '/fake_exercises_path/'
    set_exercises_root(path)
    assert_equal path, dojo.exercises.path
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test '27A597',
  'languages' do
    path = '/fake_languages_path/'
    set_languages_root(path)
    assert_equal path, dojo.languages.path
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test 'B6CC06',
  'katas' do
    path = '/fake_katas_path/'
    set_katas_root(path)
    assert_equal path, dojo.katas.path
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E640DD',
  'external git object defaults to HostGit' do
    unset('GIT')
    assert_equal 'HostGit', dojo.git.class.name
  end

  test '81CB08',
  'external runner object defaults to DockerRunner' do
    unset('RUNNER')
    assert_equal 'DockerRunner', dojo.runner.class.name
  end

  test '228760',
  'external disk object defaults to HostDisk' do
    unset('DISK')
    assert_equal 'HostDisk', dojo.disk.class.name
  end

  test '511E3E',
  'external shell object defaults to HostShell' do
    unset('SHELL')
    assert_equal 'HostShell', dojo.shell.class.name
  end

  test 'C126CA',
  'external starter object defaults to HostDiskAvatarStarter' do
    unset('STARTER')
    assert_equal 'HostDiskAvatarStarter', dojo.starter.class.name
  end

  test '03170A',
  'external log object defaults to HostLog' do
    unset('LOG')
    assert_equal 'HostLog', dojo.log.class.name
  end

  test 'E51003',
  'external one_self object defaults to OneSelfCurl' do
    unset('ONE_SELF')
    assert_equal 'OneSelfCurl', dojo.one_self.class.name
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test 'A6C799',
  'external git object can be set via CYBER_DOJO_GIT_CLASS' do
    set_git_class('ExternalDouble')
    assert_equal 'ExternalDouble', dojo.git.class.name
  end

  test 'D51880',
  'external runner can be set via CYBER_DOJO_RUNNER_CLASS' do
    set_runner_class('ExternalDouble')
    assert_equal 'ExternalDouble', dojo.runner.class.name
  end

  test 'F062B9',
  'external disk can be set via CYBER_DOJO_DISK_CLASS' do
    set_disk_class('ExternalDouble')
    assert_equal 'ExternalDouble', dojo.disk.class.name
  end

  test 'D45887',
  'external shell can be set via CYBER_DOJO_SHELL_CLASS' do
    set_shell_class('ExternalDouble')
    assert_equal 'ExternalDouble', dojo.shell.class.name
  end

  test 'F6D938',
  'external starter can be set via CYBER_DOJO_STARTER_CLASS' do
    set_starter_class('ExternalDouble')
    assert_equal 'ExternalDouble', dojo.starter.class.name
  end

  test '87B411',
  'external log can be set via CYBER_DOJO_LOG_CLASS' do
    set_log_class('ExternalDouble')
    assert_equal 'ExternalDouble', dojo.log.class.name
  end

  test 'BF6101',
  'external one_self can be set via CYBER_DOJO_ONE_SELF_CLASS' do
    set_one_self_class('ExternalDouble')
    assert_equal 'ExternalDouble', dojo.one_self.class.name
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  def unset(key)
    cd_unset('CYBER_DOJO_' + key + '_CLASS')
  end

end
