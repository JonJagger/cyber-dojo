
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
    output, _ = shell.exec('docker images')
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
