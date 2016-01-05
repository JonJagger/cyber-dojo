
# test runner providing isolation/protection/security
# via Docker containers https://www.docker.io/
# and relying on docker volume mounts of the host
# file system to give the running docker container
# access to .../katas/...

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
    _, exit_status = shell.exec('docker --version')
    exit_status == shell.success && disk[caches.path].exists?(cache_filename)
  end

  def runnable_languages
    languages.select { |language| runnable?(language.image_name) }
  end

  def cache_filename
    'docker_runner_cache.json'
  end

  # modifiers

  def run(avatar, delta, files, image_name, now, max_seconds)
    # save the files
    sandbox = avatar.sandbox
    delta[:deleted].each do |filename|
      git.rm(history.path(sandbox), filename)
    end
    delta[:new].each do |filename|
      history.write(sandbox, filename, files[filename])
      git.add(history.path(sandbox), filename)
    end
    delta[:changed].each do |filename|
      history.write(sandbox, filename, files[filename])
    end

    #run tests
    args = [
      sandbox.path,
      image_name,
      max_seconds
    ].join(space = ' ')
    output_or_killed(shell.cd_exec(path, "./docker_runner.sh #{args}"), max_seconds)
  end

  def refresh_cache
    output, _ = shell.exec('docker images')
    lines = output.split("\n").select { |line| line.start_with?('cyberdojofoundation') }
    image_names = lines.collect { |line| line.split[0] }
    caches.write_json(cache_filename, image_names)
  end

  private

  include ExternalParentChainer
  include OutputOrKilled

  def runnable?(image_name)
    image_names.include?(image_name)
  end

  def image_names
    @image_names ||= caches.read_json(cache_filename)
  end

end
