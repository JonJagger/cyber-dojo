
# test runner providing isolation/protection/security
# via Docker containers https://www.docker.io/ and relying
# on docker volume mounts of the host file system to give
# the running docker container access to .../katas/...

class DockerRunner

  def initialize(dojo)
    @dojo = dojo
  end

  # queries

  def parent
    @dojo
  end

  def path
    "#{File.dirname(__FILE__)}/"
  end

  def installed?
    _, exit_status = shell.exec("docker --version > /dev/null #{stderr_2_stdout}")
    exit_status == shell.success
  end

  def runnable_languages
    languages.select { |language| runnable?(language.image_name) }
  end

  def cache_filename
    'docker_runner_cache.json'
  end

  def config_filename
    'docker_runner_config.json'
  end

  # modifiers

  def run(id, name, delta, files, image_name, max_seconds)
    # TODO: _id _name _delta (unused)
    sandbox = katas[id].avatars[name].sandbox # TODO: drop

    # TODO: make new tmp folder (runner mix-in)
    # TODO: replace with save *all* files to tmp folder (runner mix-in)
    katas_save(sandbox, delta, files)

    #run tests
    args = [
      path_of(sandbox), # TODO: use tmp folder
      image_name,
      max_seconds
    ].join(space = ' ')

    output, exit_status = shell.cd_exec(path, "./docker_runner.sh #{args}")

    # TODO:fork { remove tmp folder } (runner mix-in)

    output_or_timed_out(output, exit_status, max_seconds)
  end

  def refresh_cache
    output, _ = shell.exec('docker images')
    lines = output.split("\n").select { |line| line.start_with?('cyberdojofoundation') }
    image_names = lines.collect { |line| line.split[0] }
    caches.write_json(cache_filename, image_names)
  end

  private

  include ExternalParentChainer
  include Runner

  def runnable?(image_name)
    image_names.include?(image_name)
  end

  def image_names
    @image_names ||= caches.read_json(cache_filename)
  end

end
