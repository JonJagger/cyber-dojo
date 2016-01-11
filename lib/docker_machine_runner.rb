
# test runner providing isolation/protection/security
# via DockerMachine run containers https://www.docker.io/
# and relying on docker volume mounts to temporary rsync'd
# locations to give docker containers access to .../katas/...

class DockerMachineRunner

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
    _, exit_status = shell.exec("docker-machine --version > /dev/null #{stderr_2_stdout}")
    exit_status == shell.success
  end

  def runnable_languages
    languages.select { |language| runnable?(language.image_name) }
  end

  def cache_filename
    'docker_machine_runner_cache.json'
  end

  def config_filename
    'docker_machine_runner_config.json'
  end

  # modifiers

  def run(id, name, delta, files, image_name, max_seconds)
    # TODO: _id _name _delta (unused)
    sandbox = katas[id].avatars[name].sandbox # TODO: drop

    # TODO: make new tmp folder (runner mix-in)
    # TODO: replace with save *all* files to tmp folder (runner mix-in)
    katas_save(sandbox, delta, files)

    #run tests
    node = node_map[image_name].sample
    args = [
      node,
      path_of(sandbox),  # TODO: use tmp folder
      image_name,
      max_seconds
    ].join(space = ' ')

    output, exit_status = shell.cd_exec(path, sudo("./docker_machine_runner.sh #{args}"));

    # TODO:fork { remove tmp folder } (runner mix-in)

    output_or_timed_out(output, exit_status, max_seconds)
  end

  def refresh_cache
    node_map = {}
    output, _exit_status = shell.exec(sudo('docker-machine ls -q'))
    nodes = output.split
    nodes.each do |node|
      output, _exit_status = shell.exec(sudo("docker-machine ssh #{node} -- sudo docker images"))
      lines = output.split("\n").select { |line| line.start_with?('cyberdojofoundation') }
      image_names = lines.collect { |line| line.split[0] }
      image_names.each do |image_name|
        node_map[image_name] ||= []
        node_map[image_name] << node
      end
    end
    caches.write_json(cache_filename, node_map)
  end

  private

  include ExternalParentChainer
  include Runner

  def runnable?(image_name)
    !node_map[image_name].nil?
  end

  def node_map
    @node_map ||= caches.read_json(cache_filename)
  end

  def sudo(command)
    # docker-machine works by setting up environment variables telling
    # the subsequent [docker run] command which node to run on.
    # Some of these environment variables are file paths.
    # These paths take the form ~/.docker/machine/...
    # Thus the [docker-machine create] commands to setup the nodes have
    # to be run as a user which can have environment variables.
    # Which means it can't be www-data (which doesn't have a login shell).
    # The username I choose is cyber-dojo.
    # Note that this is a real user (the rsync cyber-dojo user is not).
    'sudo -u cyber-dojo ' + command
  end

end

