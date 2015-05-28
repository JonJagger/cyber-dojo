#!/usr/bin/env ../test_wrapper.sh lib

require_relative 'lib_test_base'

class DockerRunnerTests < LibTestBase

  def setup
    super
    @bash = BashStub.new    
    set_disk_class_name     'DiskStub'    
    set_git_class_name      'GitSpy'   
    set_one_self_class_name 'OneSelfDummy'     
    kata = make_kata
    @lion = kata.start_avatar(['lion'])    
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when docker is not installed constructor raises' do    
    @bash.stub('',any_non_zero=42)
    assert_raises(RuntimeError) { DockerRunner.new(@bash) }
    assert @bash.spied[0].start_with? 'docker info'
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when docker is installed, image_names determines runnability' do
    @bash.stub(docker_info_output, success)
    @bash.stub(docker_images_output, success)
    docker = DockerRunner.new(@bash)    
    expected_image_names =
    [
      "cyberdojo/python-3.3.5_pytest",
      "cyberdojo/rust-1.0.0_test"
    ]
    c_assert = languages['C-assert']
    python_py_test = languages['Python-py.test']

    assert @bash.spied[0].start_with?('docker info'), @bash.spied
    assert @bash.spied[1].start_with?('docker images'), @bash.spied    
    assert_equal expected_image_names, docker.image_names        
    refute docker.runnable?(c_assert);
    assert docker.runnable?(python_py_test);
  end
    
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'docker run <-> bash interaction when cyber-dojo.sh completes in time' do
    @bash.stub(docker_info_output, success)   # 0
    @bash.stub(docker_images_output, success) # 1
    docker = DockerRunner.new(@bash)
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
    docker = DockerRunner.new(@bash)
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
    cidfile = @lion.path + "cidfile.txt"
    assert_equal "rm -f #{cidfile}", @bash.spied[2], 'rm -f'
    run_cmd = @bash.spied[3]
    assert run_cmd.start_with?("timeout --signal=#{kill} #{max_seconds+5}s"), 'timeout (outer)'
    assert run_cmd.include?("docker run"), 'docker run'
    assert run_cmd.include?("--cidfile=#{quoted(cidfile)}"), 'cidfile'
    assert run_cmd.include?("timeout --signal=#{kill} #{max_seconds}s #{cmd}"), 'timeout (inner)'
    assert_equal "cat #{cidfile}",                        @bash.spied[4], 'cat cidfile'
    assert_equal "docker stop #{pid} ; docker rm #{pid}", @bash.spied[5], 'docker stop+rm'    
  end
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
  def docker_info_output
    [
      "Containers: 6",
      "Images: 440",
      "Storage Driver: aufs",
      "Root Dir: /var/lib/docker/aufs",
      "Dirs: 452",
      "Execution Driver: native-0.2",
      "Kernel Version: 3.2.0-4-amd64",
      "Username: cyberdojo",
      "Registry: [https://index.docker.io/v1/]",
      "WARNING: No memory limit support",
      "WARNING: No swap limit support"
    ].join("\n")
  end
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  def docker_images_output
    [
      "REPOSITORY                       TAG     IMAGE ID      CREATED        VIRTUAL SIZE",
      "<none>                           <none>  b7253690a1dd  2 weeks ago    1.266 GB",
      "cyberdojo/python-3.3.5_pytest    latest  d9603e342b22  13 months ago  692.9 MB",
      "cyberdojo/rust-1.0.0_test        latest  a8e2d9d728dc  2 weeks ago    750.3 MB",
      "<none>                           <none>  0ebf80aa0a8a  2 weeks ago    569.8 MB"
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
