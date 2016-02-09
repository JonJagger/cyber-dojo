
# used by docker_tmp_runner.rb and docker_katas_runner.rb

module DockerRunner # mixin

  def path
    "#{File.dirname(__FILE__)}/"
  end

  def runnable_languages
    languages.select { |language| runnable?(language.image_name) }
  end

  module_function

  include ExternalParentChainer
  include Runner

  def make_cache
    # If cyber-dojo is running inside a docker container (docker in docker)
    # then [docker images] must be made by a user that has sufficient rights.
    # The default user is root, but this can be altered in the Dockerfile.
    output, _ = shell.exec('docker images')
    # This will put all image names (eg alpine_base) into the runner cache,
    # even base image names such as alpine_base. This is harmless.
    lines = output.split("\n").select { |line| line.start_with?('cyberdojofoundation') }
    lines.collect { |line| line.split[0] }
  end

  def runnable?(image_name)
    image_names.include?(image_name)
  end

  def image_names
    @image_names ||= read_cache
  end

  def read_cache
    caches.read_json(cache_filename)
  end

  def cache_filename
    'runner_cache.json'
  end

end
