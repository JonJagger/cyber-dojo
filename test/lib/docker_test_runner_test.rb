#!/usr/bin/env ../test_wrapper.sh lib

require_relative 'lib_test_base'

class BashStub
  
  def initialize
    @stubbed,@spied = [],[]
    @index = 0
  end

  attr_reader :spied

  def stub(output,exit_status)
    @stubbed << [output,exit_status]
  end
  
  def exec(command)
    @spied << command
    stub = @stubbed[@index]
    @index += 1
    return *stub
  end
  
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - -

class DockerTestRunnerTests < LibTestBase

  def setup
    super
    @bash = BashStub.new    
  end

  test 'when docker is not installed constructor raises' do    
    @bash.stub('',any_non_zero=42)
    assert_raises(RuntimeError) { DockerTestRunner.new(@bash) }
    assert @bash.spied[0].start_with? 'docker info'
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when docker is installed, image_names determines runnability' do
    @bash.stub(docker_info_output, success)
    @bash.stub(docker_images_output, success)
    docker = DockerTestRunner.new(@bash)
    
    assert @bash.spied[0].start_with?('docker info'), @bash.spied
    assert @bash.spied[1].start_with?('docker images'), @bash.spied
    
    expected_image_names =
    [
      "cyberdojo/python-3.3.5_pytest",
      "cyberdojo/rust-1.0.0_test"
    ]
    assert_equal expected_image_names, docker.image_names
    
    set_disk_class_name 'DiskStub'    
    python_py_test = languages['Python-py.test']
    assert docker.runnable?(python_py_test);
    c_assert = languages['C-assert']
    refute docker.runnable?(c_assert);
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
  
  def docker_images_output
    [
      "REPOSITORY                              TAG                 IMAGE ID            CREATED             VIRTUAL SIZE",
      "<none>                                  <none>              b7253690a1dd        2 weeks ago         1.266 GB",
      "cyberdojo/python-3.3.5_pytest           latest              d9603e342b22        13 months ago       692.9 MB",
      "cyberdojo/rust-1.0.0_test               latest              a8e2d9d728dc        2 weeks ago         750.3 MB",
      "<none>                                  <none>              0ebf80aa0a8a        2 weeks ago         569.8 MB"
    ].join("\n")  
  end
  
  def success
    0
  end
  
end
