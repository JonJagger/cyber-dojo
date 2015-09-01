
module DockerTestHelpers # mix-in

  module_function

  def stub_docker_installed
    @bash.stub(docker_info_output, success)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def stub_docker_not_installed
    @bash.stub('',any_non_zero=42)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def stub_docker_images_python_py_test
    @bash.stub(docker_images_python_py_test, success)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def stub_git_push;    @bash.stub('',success);  end
  def stub_rm_cidfile;  @bash.stub('',success);  end
  def stub_timeout(n);  @bash.stub('blah',n);    end
  def stub_cat_cidfile; @bash.stub(pid,success); end
  def stub_docker_stop; @bash.stub('',success);  end
  def stub_docker_rm;   @bash.stub('',success);  end

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

  def docker_images_python_py_test
    [
      'REPOSITORY                                 TAG     IMAGE ID      CREATED        VIRTUAL SIZE',
      '<none>                                     <none>  b7253690a1dd  2 weeks ago    1.266 GB',
      'cyberdojofoundation/python-3.3.5_pytest    latest  d9603e342b22  13 months ago  692.9 MB',
      '<none>                                     <none>  0ebf80aa0a8a  2 weeks ago    569.8 MB'
    ].join("\n")
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def cid_filename; 'stub.cid'; end

  def cyber_dojo_cmd; 'cyber-dojo.sh'; end

  def max_seconds; 5; end

  def pid; '921'; end

  def completes; 0; end

  def times_out; fatal_error(kill); end

  def success; 0; end

  def kill; 9; end

  def fatal_error(signal); 128 + signal; end

  def quoted(s); '"' + s + '"'; end

end
