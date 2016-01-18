
# test runner providing isolation/protection/security
# via docker-run images https://www.docker.io/
# Saves the incoming files off /tmp/ and then relies
# on its associated .sh file to do a [docker run] command
# which volume mounts the tmp folder.
# Each run event saves the incoming visible-files to a *new*
# tmp folder. Each saved file will have a new date-time stamp.
# No state is retained across run events. This means cyber-dojo.sh
# will not be able to do incremental makes (for example).

class DockerTmpRunner

  def initialize(dojo)
    @dojo = dojo
    @tmp_path = unique_tmp_path
  end

  # queries

  attr_reader :tmp_path

  def parent
    @dojo
  end

  def config_filename
    'docker_tmp_runner_config.json'
  end

  # modifiers

  def run(_id, _name, _delta, files, image_name, max_seconds)
    write_files(tmp_path, files)
    args = [ tmp_path, image_name, max_seconds ].join(space = ' ')
    output, exit_status = shell.cd_exec(path, "./docker_runner.sh #{args}")
    fork { shell.exec("rm -rf #{tmp_path}") }
    output_or_timed_out(output, exit_status, max_seconds)
  end

  private

  include DockerRunner

end
