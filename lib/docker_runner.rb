
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

# The docker runners each have a cache related to which docker-images have been pulled
# and are *already* present and usable on the server (and possibly on which node they reside)
# It is NOT the case that the create languages+test page lists *all* the languages+tests
# and when you press test the language+tests's docker image is pulled on demand.
