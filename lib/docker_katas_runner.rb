
# test runner providing isolation/protection/security
# via docker-run images https://www.docker.io/
# Saves the incoming files off .../katas/ and then relies
# on its associated .sh file to do a [docker run] command
# which volume mounts the .../katas/ sub-folder.
# Each run event saves the incoming visible-files to the *same*
# katas sub-folder. Untouched files will retain the same date-time stamp.
# State *is* retained across run events. This means cyber-dojo.sh
# will be able to do incremental makes (for example).
# It also means any horizontal scaling of this runner
# is necessarily tied to HostDiskKatas.

class DockerKatasRunner

  def initialize(dojo)
    @dojo = dojo
    raise "sorry can't do that" if katas.class.name != 'HostDiskKatas'
  end

  # queries

  def parent
    @dojo
  end

  def config_filename
    'docker_katas_runner_config.json'
  end

  # modifiers

  def run(id, name, delta, files, image_name, max_seconds)
    sandbox = katas[id].avatars[name].sandbox
    katas.sandbox_save(sandbox, delta, files)
    args = [ katas.path_of(sandbox), image_name, max_seconds ].join(space = ' ')
    output, exit_status = shell.cd_exec(path, "./docker_runner.sh #{args}")
    output_or_timed_out(output, exit_status, max_seconds)
  end

  private

  include DockerRunner

end
