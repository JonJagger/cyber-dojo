
# o) Saves *all* files to a *new* /tmp sub-folder inside the test container
# o) State is *not* retained across tests.
# o) Untouched files get a *new* date-time stamp.
# o) cyber-dojo.sh *cannot* do incremental makes.
# o) Easier to scale than DockerKatasRunner

class DockerTmpRunner

  def initialize(dojo)
    @dojo = dojo
    #@tmp_path = unique_tmp_path
    caches.write_json_once(cache_filename) { make_cache }
  end

  # queries

  attr_reader :tmp_path

  def parent
    @dojo
  end

  # modifiers

  def run(id, name, delta, files, image_name, max_seconds)
    sandbox = katas[id].avatars[name].sandbox
    katas.sandbox_save(sandbox, delta, files)
    katas_sandbox_path = katas.path_of(sandbox)
    args = [ katas_sandbox_path, image_name, max_seconds ].join(space = ' ')
    #write_files(tmp_path, files)
    #args = [ tmp_path, image_name, max_seconds ].join(space = ' ')
    output, exit_status = shell.cd_exec(path, "./docker_tmp_runner.sh #{args}")
    #shell.exec("rm -rf #{tmp_path}")
    output_or_timed_out(output, exit_status, max_seconds)
  end

  private

  include DockerRunner

end
