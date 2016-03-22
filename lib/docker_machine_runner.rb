
# Saves the incoming files off /tmp/ and then relies on
# its associated .sh file to
# o) issue a [docker-machine env $(node)]
# o) issue a [docker-machine scp ... $(node)] to copy the
#    files to the node
# o) issue a [docker run ...] to run the container on the node
#    which will volume mount the folder where step 2 scp'd
#    the files to.

class DockerMachineRunner

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

  def path
    "#{File.dirname(__FILE__)}/"
  end

  def runnable_languages
    languages.select { |language| runnable?(language.image_name) }
  end

  # modifiers

  def run(_id, _name, _delta, files, image_name, max_seconds)
    write_files(tmp_path, files)
    node = node_map[image_name].sample
    args = [ node, tmp_path, image_name, max_seconds ].join(space = ' ')
    output, exit_status = shell.cd_exec(path, sudo("./docker_machine_runner.sh #{args}"));
    shell.exec("rm -rf #{tmp_path}")
    output_or_timed_out(output, exit_status, max_seconds)
  end

  private

  include ExternalParentChainer
  include Runner

  def make_cache
    cache = {}
    output, _exit_status = shell.exec(sudo('docker-machine ls -q'))
    nodes = output.split
    nodes.each do |node|
      output, _exit_status = shell.exec(sudo("docker-machine ssh #{node} -- sudo docker images"))
      lines = output.split("\n").select { |line| line.start_with?('cyberdojofoundation') }
      image_names = lines.collect { |line| line.split[0] }
      image_names.each do |image_name|
        cache[image_name] ||= []
        cache[image_name] << node
      end
    end
    cache
  end

  def runnable?(image_name)
    !node_map[image_name].nil?
  end

  def node_map
    @node_map ||= read_cache
  end

  def read_cache
    caches.read_json(cache_filename)
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
    'sudo -u cyber-dojo ' + command
  end

  def cache_filename
    'runner_cache.json'
  end

end

