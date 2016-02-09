
# test runner providing isolation/protection/security
# via docker-run images https://www.docker.io/
#
# o) Each test saves *changed* files to the avatar's katas/... sub-folder.
# o) State *is* retained across tests.
# o) Untouched files retain the *same* date-time stamp.
# o) cyber-dojo.sh *can* do incremental makes.
# o) Horizontal scaling of this runner *is* tied to katas/....

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
    shell.exec("chown -R #{user}:#{user} #{katas_sandbox_path}")
    args = [ katas_sandbox_path, image_name, max_seconds, user ].join(space = ' ')
    output, exit_status = shell.cd_exec(path, "./docker_runner.sh #{args}")
    output_or_timed_out(output, exit_status, max_seconds)
  end

  private

  include DockerRunner

  def user
    # see comments in languages/alpine_base/_docker_context/Dockerfile
    'www-data'
  end

end
