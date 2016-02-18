
# o) Each test saves the visible-files to the same katas/id/ sub-folder.
# o) katas/... can be a volume-mount or a data-container
# o) State is retained across tests.
# o) Untouched files retain the same date-time stamp.
# o) cyber-dojo.sh can do incremental makes.

class DockerKatasRunner

  def initialize(dojo)
    @dojo = dojo
    caches.write_json_once(cache_filename) { make_cache }
  end

  # queries

  def parent
    @dojo
  end

  # modifiers

  def run(id, name, delta, files, image_name, max_seconds)
    sandbox = katas[id].avatars[name].sandbox
    katas.sandbox_save(sandbox, delta, files)
    katas_sandbox_path = katas.path_of(sandbox)
    args = [ katas_sandbox_path, image_name, max_seconds ].join(space = ' ')
    output, exit_status = shell.cd_exec(path, "./docker_katas_runner.sh #{args}")
    output_or_timed_out(output, exit_status, max_seconds)
  end

  private

  include DockerRunner

end
