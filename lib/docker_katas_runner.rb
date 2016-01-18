
# test runner providing isolation/protection/security
# via docker-run images https://www.docker.io/
#
# Saves the incoming files off .../katas/ and then relies
# on its associated .sh file to do a [docker run] command
# which volume mounts the .../katas/ sub-folder.
#
# o) Each test saves the visible-files to the *same* katas sub-folder.
# o) State *is* retained across tests.
# o) Untouched files retain the *same* date-time stamp.
# o) cyber-dojo.sh *can* do incremental makes.
# o) Horizontal scaling of this runner *is* tied to HostDiskKatas.

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
