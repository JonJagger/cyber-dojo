
# test runner providing isolation/protection/security
# via Docker containers https://www.docker.io/
# and relying on docker volume mounts on host to
# give /katas/ state access to docker process containers.
#
# Comments at end of file

class DockerRunner2

  def self.cache_filename
    'docker_runner_cache.json'
  end

  def initialize(caches, bash = Bash.new)
    @caches = caches
    @bash = bash
  end

  def runnable?(language)
    image_names.include?(language.image_name)
  end

  def run(sandbox, command, max_seconds)
    cmd = "/var/www/cyber-dojo/lib/docker_runner.sh" +
          " #{sandbox.path}" +
          " #{sandbox.avatar.kata.language.image_name}" +
          " #{max_seconds}"
    output, exit_status = @bash.exec(cmd)
    # sanitize
    output
  end

  def refresh_cache
    output, _ = bash('docker images')
    lines = output.split("\n").select { |line| line.start_with?('cyberdojofoundation') }
    cache = lines.collect { |line| line.split[0] }
    caches.write_json(self.class.cache_filename, cache)
  end

  private

  attr_reader :caches

  def image_names
    @image_names ||= caches.read_json(self.class.cache_filename)
  end

end

