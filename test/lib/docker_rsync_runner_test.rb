#!/bin/bash ../test_wrapper.sh

require_relative './LibTestBase'
require_relative './DockerTestHelpers'
require 'resolv'

class DockerRsyncRunnerTests < LibTestBase

  include DockerTestHelpers

  def setup
    super
    set_disk_class     'DiskStub'
    set_git_class      'GitSpy'
    set_one_self_class 'OneSelfDummy'
    @lion = make_kata.start_avatar(['lion'])
    @bash = BashStub.new
  end

  def make_docker_runner
    @runner = DockerRsyncRunner.new(@bash,cid_filename)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '72C7DE',
  'raises RuntimeError(Docker not installed) when docker is not installed' do
    stub_docker_not_installed
    assert_raises(RuntimeError,'Docker not installed') { make_docker_runner }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '888002',
  'raises RuntimeError(bad ip address) when docker installed but bad ip address' do
    stub_docker_installed
    stub_ip_address(bad_ip)
    assert_raises(RuntimeError,'bad ip address') { make_docker_runner }    
  end
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'ED0EA2',
  'initialize() uses [docker info] not run as sudo' do
    stub_docker_installed
    stub_ip_address(good_ip)
    make_docker_runner
    determine_ip_cmd = "ip route show | grep docker0 | awk '{print $9}'" 
    assert_equal determine_ip_cmd, @bash.spied[1]
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'EBB1D5',
  'runnable?(language) uses [docker images] not run as sudo' do
    stub_docker_installed
    stub_ip_address(good_ip)
    docker = make_docker_runner
    stub_docker_images_python_py_test
    assert docker.runnable?(languages['Python-py.test']), 'python_py_test'
    refute docker.runnable?(languages['C-assert']),       'c_assert'
    assert_equal 'docker images', @bash.spied[2]
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'D2D2C2',
  'run() completes and does not timeout - exact bash cmd interaction' do
    stub_docker_installed
    stub_ip_address(good_ip)
    make_docker_runner
    stub_docker_run(completes)
    output = @runner.run(@lion.sandbox, cyber_dojo_cmd, max_seconds)
    assert_equal 'blah',output, 'output'
    assert_bash_commands_spied
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'A470A8',
  'run() times out - exact bash cmd interaction' do
    stub_docker_installed
    stub_ip_address(good_ip)    
    make_docker_runner
    stub_docker_run(times_out)
    output = @runner.run(@lion.sandbox, cyber_dojo_cmd, max_seconds)
    assert output.start_with?("Unable to complete the tests in #{max_seconds} seconds."), 'Unable'
    assert_bash_commands_spied
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def stub_ip_address(ip)
    ip_ok = (ip =~ Resolv::IPv4::Regex) === 0
    exit_status = ip_ok ? 0 : 7
    @bash.stub(ip, exit_status)
  end

  def good_ip; '192.168.1.72'; end

  def bad_ip; '-bash: awk: command not found'; end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_bash_commands_spied
    spied = @bash.spied
    # 0 docker info from initialize()
    # 1 ip-address determination from initialize()
    assert_equal "rm -f #{cid_filename}", spied[2], 'remove cidfile'
    assert_equal exact_docker_run_cmd,    spied[3], 'main docker run command'
    assert_equal "cat #{cid_filename}",   spied[4], 'get pid from cidfile'
    assert_equal "docker stop #{pid}",    spied[5], 'docker stop pid'
    assert_equal "docker rm #{pid}",      spied[6], 'docker rm pid'
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  include IdSplitter

  def exact_docker_run_cmd
    id = @lion.kata.id

    rsync_cmd =
      [
        "rsync -rtW rsyncclient@#{good_ip}::katas/#{outer(id)}/#{inner(id)}/lion/sandbox /tmp",
        "cd /tmp/sandbox && timeout --signal=#{kill} #{max_seconds}s #{cyber_dojo_cmd} 2>&1"
      ].join(';')

    "timeout --signal=#{kill} #{max_seconds+5}s" +
      ' docker run' +
        ' --user=www-data' +
        " --cidfile=#{quoted(cid_filename)}" +
        " -e RSYNC_PASSWORD='password'" +
        " #{@lion.kata.language.image_name}" +
        " /bin/bash -c #{quoted(rsync_cmd)} 2>&1"
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # MiniTest is documented to allow trailing string as message
  # but I can't get it working so I've rolled my own

  def assert_raises(klass,msg,&block)
    begin
      block.call
      flunk "assert_raises(#{klass},#{msg}) did not raise"
    rescue => e
      diagnostic = "#{klass}.new() got #{e.class}.new()"
      assert klass.class === e.class, "expecting #{diagnostic}"
      diagnostic = "#{klass}.new(#{msg}) got #{klass}.new(#{e.message})"
      assert msg === e.message, "expecting #{diagnostic}"
    end
  end

end
