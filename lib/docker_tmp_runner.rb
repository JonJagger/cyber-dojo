
# test runner providing isolation/protection/security
# via docker-run images https://www.docker.io/
#
# Saves the incoming files off /tmp/ and then relies
# on the associated .sh file to do a [docker run] command
# which volume mounts the tmp sub-folder.
#
# o) Each test saves the visible-files to a *new* tmp folder.
# o) State is *not* retained across tests.
# o) Untouched files get a *new* date-time stamp.
# o) cyber-dojo.sh *cannot* do incremental makes.
# o) Horizontal scaling of this runner is *not* tied to HostDiskKatas.

class DockerTmpRunner

  def initialize(dojo)
    @dojo = dojo
    @tmp_path = unique_tmp_path
    caches.write_json_once(cache_filename) { make_cache }
  end

  # queries

  attr_reader :tmp_path

  def parent
    @dojo
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
