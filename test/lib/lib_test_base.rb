
require_relative '../test_coverage'
require_relative '../all'
require_relative '../test_base'

class LibTestBase < TestBase

  def stub_docker_installed
    @bash.stub(docker_info_output, success)   # 0
    @bash.stub(docker_images_output, success) # 1
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def stub_docker_not_installed
    @bash.stub('',any_non_zero=42)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def stub_docker_run(outcome)
    stub_rm_cidfile       # 2
    stub_timeout(outcome) # 3
    stub_cat_cidfile      # 4
    stub_docker_stop      # 5
    stub_docker_rm        # 6
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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

  def docker_images_output
    [
      'REPOSITORY                       TAG     IMAGE ID      CREATED        VIRTUAL SIZE',
      '<none>                           <none>  b7253690a1dd  2 weeks ago    1.266 GB',
      'cyberdojo/python-3.3.5_pytest    latest  d9603e342b22  13 months ago  692.9 MB',
      'cyberdojo/rust-1.0.0_test        latest  a8e2d9d728dc  2 weeks ago    750.3 MB',
      '<none>                           <none>  0ebf80aa0a8a  2 weeks ago    569.8 MB'
    ].join("\n")
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def pid; '921'; end

  def completes; 0; end

  def times_out; fatal_error(kill); end

  def success; 0; end

  def kill; 9; end

  def fatal_error(signal); 128 + signal; end

  def quoted(s); '"' + s + '"'; end

end
