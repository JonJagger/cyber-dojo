
# test runner providing isolation/protection/security
# via DockerMachine containers https://www.docker.io/
# and relying on docker volume mounts on nodes to
# give docker containers access to .../katas/...

class DockerMachineRunner

  def self.cache_filename
    'docker_machine_runner_cache.json'
  end

  def initialize(caches, bash = Bash.new)
    @caches = caches
    @bash = bash
  end

  def runnable?(image_name)
    !node_map[image_name].nil?
  end

  def run(sandbox, max_seconds)
    language = sandbox.avatar.kata.language
    node = node_map[language.image_name].sample
    cmd = "#{File.dirname(__FILE__)}/docker_machine_runner.sh" +
          " #{node}" +
          " #{sandbox.path}" +
          " #{language.image_name}" +
          " #{max_seconds}"
    output, exit_status = bash.exec(sudo(cmd))
    exit_status != timed_out ? output : did_not_complete_in(max_seconds)
  end

  def refresh_cache
    node_map = {}
    output, _exit_status = bash.exec(sudo('docker-machine ls -q'))
    nodes = output.split
    nodes.each do |node|
      output, _exit_status = bash.exec(sudo("docker-machine ssh #{node} -- sudo docker images"))
      lines = output.split("\n").select { |line| line.start_with?('cyberdojofoundation') }
      image_names = lines.collect { |line| line.split[0] }
      image_names.each do |image_name|
        node_map[image_name] ||= []
        node_map[image_name] << node
      end
    end
    caches.write_json(self.class.cache_filename, node_map)
  end

  private

  include DidNotCompleteIn

  attr_reader :caches, :bash

  def node_map
    @node_map ||= caches.read_json(self.class.cache_filename)
  end

  def timed_out
    (timeout=128) + (kill=9)
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
    # Note that this is a real user, (the rsync cyber-dojo user is not).
    'sudo -u cyber-dojo ' + command
  end

end

