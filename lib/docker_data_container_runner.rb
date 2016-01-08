
# test runner providing isolation/protection/security
# via Docker containers https://www.docker.io/
# and relying on docker volume mounts of a docker
# data-container to give the running docker-container
# access to .../katas/...
#
# To see how to build and create the katas data-container
# see /var/www/cyber-dojo/docer_images_kata/

class DockerDataContainerRunner

  def self.cache_filename
    'docker_runner_cache.json'
  end

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

  def runnable_languages
    languages.select { |language| runnable?(language.image_name) }
  end

  # modifiers

  def run(id, name, delta, files, image_name, max_seconds)
    sandbox = katas[id].avatars[name].sandbox
    katas_save(sandbox, delta, files)
    args = [
      path_of(sandbox),
      image_name,
      max_seconds
    ].join(space = ' ')
    output, exit_status = shell.cd_exec(path, "./docker_data_container_runner.sh #{args}")
    output_or_timed_out(output, exit_status, max_seconds)
  end

  def refresh_cache
    output, _ = shell.exec('docker images')
    lines = output.split("\n").select { |line| line.start_with?('cyberdojofoundation') }
    image_names = lines.collect { |line| line.split[0] }
    caches.write_json(self.class.cache_filename, image_names)
  end

  private

  include ExternalParentChainer
  include Runner

  def runnable?(image_name)
    image_names.include?(image_name)
  end

  def image_names
    @image_names ||= caches.read_json(self.class.cache_filename)
  end

end
