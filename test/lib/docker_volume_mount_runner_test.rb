#!/usr/bin/env ../test_wrapper.sh lib

require_relative 'lib_test_base'

class DockerVolumeMountRunnerTests < LibTestBase

  def setup
    super
    @bash = BashStub.new
    @cid_filename = 'stub.cid'
    set_disk_class_name     'DiskStub'
    set_git_class_name      'GitSpy'
    set_one_self_class_name 'OneSelfDummy'
    @id = '12345ABCDE'
    kata = make_kata(@id)
    @lion = kata.start_avatar(['lion'])
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when docker is not installed constructor raises' do
    @bash.stub('',any_non_zero=42)
    assert_raises(RuntimeError) { make_docker_runner }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'bash commands run in initialize() do not sudo' do
    @bash.stub(docker_info_output, success)
    @bash.stub(docker_images_output, success)
    make_docker_runner
    assert @bash.spied[0].start_with?('docker info'), 'docker info'
    assert @bash.spied[1].start_with?('docker images'), 'docker images'
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when docker is installed, image_names determines runnability' do
    @bash.stub(docker_info_output, success)
    @bash.stub(docker_images_output, success)
    docker = make_docker_runner    
    expected_image_names =
    [
      "cyberdojo/python-3.3.5_pytest",
      "cyberdojo/rust-1.0.0_test"
    ]
    c_assert = languages['C-assert']
    python_py_test = languages['Python-py.test']

    assert_equal expected_image_names, docker.image_names        
    refute docker.runnable?(c_assert);
    assert docker.runnable?(python_py_test);
  end
    
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'started(avatar) is a no-op' do
    @bash.stub(docker_info_output, success)
    @bash.stub(docker_images_output, success)
    docker = make_docker_runner
    assert_equal 2, @bash.spied.size, 'before'
    docker.started(nil)
    assert_equal 2, @bash.spied.size, 'after'
  end
    
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'pre_test(avatar) is a no-op' do
    @bash.stub(docker_info_output, success)
    @bash.stub(docker_images_output, success)
    docker = make_docker_runner
    assert_equal 2, @bash.spied.size, 'before'
    docker.pre_test(nil)
    assert_equal 2, @bash.spied.size, 'after'
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'docker run exact bash interaction to refactor against' do
    @bash.stub(docker_info_output, success)
    @bash.stub(docker_images_output, success)
    docker = make_docker_runner
    @bash.stub('',success)        # 2 rm cidfile.txt
    @bash.stub('blah',success)    # 3 timeout ... docker run ...
    @bash.stub(pid='921',success) # 4 cat ... cidfile.txt
    @bash.stub('',success)        # 5 docker stop pid ; docker rm pid
    cmd = 'cyber-dojo.sh'
    output = docker.run(@lion.sandbox, cmd, max_seconds=5)

    language = @lion.kata.language
    language_path = language.path
    none = 'none'
    language_volume_mount = language_path + ':' + language_path + ":ro"
    kata_volume_mount = @lion.sandbox.path + ":/sandbox:rw"

    cmd = "timeout --signal=9 5s cyber-dojo.sh 2>&1"
    expected =
      'timeout --signal=9 10s' +
        ' docker run' +
          ' --user=www-data' +
          " --cidfile=#{quoted(@cid_filename)}" +
   '  ' + " --net=#{quoted(none)}" +
          " -v #{quoted(language_volume_mount)}" +
          " -v #{quoted(kata_volume_mount)}" +
          ' -w /sandbox' +
          " #{language.image_name}" +
          " /bin/bash -c #{quoted(cmd)} 2>&1"

    actual = @bash.spied[3]
    assert actual.start_with?(expected), 'start_with'
    assert_equal expected, actual, 'equal'
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'docker run <-> bash interaction when cyber-dojo.sh completes in time' do
    @bash.stub(docker_info_output, success)   # 0
    @bash.stub(docker_images_output, success) # 1
    docker = make_docker_runner
    begin
      @bash.stub('',success)        # 2 rm cidfile.txt
      @bash.stub('blah',success)    # 3 timeout ... docker run ...
      pid = '921'
      @bash.stub(pid,success)       # 4 cat ... cidfile.txt
      @bash.stub('',success)        # 5 docker stop pid ; docker rm pid      
      cmd = 'cyber-dojo.sh'
      output = docker.run(@lion.sandbox, cmd, max_seconds=5)      
      assert_equal 'blah',output, 'output'      
      assert_spied(max_seconds, cmd, pid)
    rescue Exception => e  
      p e.message
      @bash.dump
      assert false
    end
  end    
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'docker run <-> bash interaction when cyber-dojo.sh times out' do
    @bash.stub(docker_info_output, success)   # 0
    @bash.stub(docker_images_output, success) # 1
    docker = make_docker_runner
    begin
      @bash.stub('',success)               # 2 rm cidfile.txt
      @bash.stub('blah',fatal_error(kill)) # 3 timeout ... docker run ...
      pid = '921'
      @bash.stub(pid,success)              # 4 cat ... cidfile.txt
      @bash.stub('',success)               # 5 docker stop pid ; docker rm pid      
      cmd = 'cyber-dojo.sh'
      output = docker.run(@lion.sandbox, cmd, max_seconds=5)      
      assert output.start_with?("Unable to complete the tests in #{max_seconds} seconds."), 'Unable'      
      assert_spied(max_seconds, cmd, pid)
    rescue Exception => e
      p e.message
      @bash.dump    
      assert false
    end
  end
    
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  def assert_spied(max_seconds, cmd, pid)
    run_cmd = @bash.spied[3]
    expected = "timeout --signal=#{kill} #{max_seconds+5}s"
    assert run_cmd.start_with?(expected), 'timeout(outer)'
    expected = "timeout --signal=#{kill} #{max_seconds}s cyber-dojo.sh"
    assert run_cmd.include?(expected), 'timeout(inner)'    
    
    assert run_cmd.include?('docker run'), 'docker run'
    assert run_cmd.include?('--user=www-data'), 'user inside docker container is www-data'
    assert run_cmd.include?("--cidfile="), 'explicit cidfile'
    refute run_cmd.include?('--rm'), 'rm is *not* specified'
    assert run_cmd.include?('-v "/var/www/cyber-dojo/languages'), 'volume mount languages/'
    assert run_cmd.include?('-v "/var/www/cyber-dojo/katas'), 'volume mount katas/'
    assert_equal "docker stop #{pid} ; docker rm #{pid}", @bash.spied[5], 'docker stop+rm'    
  end
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
  def make_docker_runner
    DockerVolumeMountRunner.new(@bash,@cid_filename)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
  def docker_info_output
    [
      'Containers: 6',
      'Images: 440',
      'Storage Driver: aufs',
      'Root Dir: /var/lib/docker/aufs',
      'Dirs: 452',
      'Execution Driver: native-0.2',
      'Kernel Version: 3.2.0-4-amd64',
      'Username: cyberdojo',
      'Registry: [https://index.docker.io/v1/]',
      'WARNING: No memory limit support',
      'WARNING: No swap limit support'
    ].join("\n")
  end
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  def docker_images_output
    [
      'REPOSITORY                       TAG     IMAGE ID      CREATED        VIRTUAL SIZE',
      '<none>                           <none>  b7253690a1dd  2 weeks ago    1.266 GB',
      'cyberdojo/python-3.3.5_pytest    latest  d9603e342b22  13 months ago  692.9 MB',
      'cyberdojo/rust-1.0.0_test        latest  a8e2d9d728dc  2 weeks ago    750.3 MB',
      '<none>                           <none>  0ebf80aa0a8a  2 weeks ago    569.8 MB'
    ].join("\n")  
  end
  
  def success
    0
  end
  
  def kill
    9
  end
  
  def fatal_error(signal)
    128 + signal
  end
  
  def quoted(s)
    '"' + s + '"'
  end
  
end
