
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

  def runnable?(image_name)
    image_names.include?(image_name)
  end

  def image_names
    @image_names ||= make_cache
  end

  def make_cache
    # [docker images] must be made by a user that has sufficient rights.
    # See docker/web/Dockerfile
    sudo = parent.env('runner', 'sudo')
    output, _ = shell.exec("#{sudo} docker images")
    # This will put all cyberdojofoundation image names into the runner cache,
    # even nginx and web. This is harmless.
    lines = output.split("\n").select { |line| line.start_with?('cyberdojofoundation') }
    lines.collect { |line| line.split[0] }
  end

end
