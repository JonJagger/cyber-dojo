
# test runner providing isolation/protection/security
# via Docker containers https://www.docker.io/
# and relying on docker volume mounts on host to
# give docker containers access to .../katas/...

class DockerRunner

  def self.cache_filename
    'docker_runner_cache.json'
  end

  def initialize(caches, bash = Bash.new)
    @caches = caches
    @bash = bash
  end

  def runnable?(image_name)
    image_names.include?(image_name)
  end

  def run(sandbox, max_seconds)
    cmd = "#{File.dirname(__FILE__)}/docker_runner.sh" +
          " #{sandbox.path}" +
          " #{sandbox.avatar.kata.language.image_name}" +
          " #{max_seconds}"
    output, exit_status = bash.exec(cmd)
    exit_status != timed_out ? output : did_not_complete_in(max_seconds)
  end

  def refresh_cache
    output, _ = bash.exec('docker images')
    lines = output.split("\n").select { |line| line.start_with?('cyberdojofoundation') }
    image_names = lines.collect { |line| line.split[0] }
    caches.write_json(self.class.cache_filename, image_names)
  end

  private

  include DidNotCompleteIn

  attr_reader :caches, :bash

  def image_names
    @image_names ||= caches.read_json(self.class.cache_filename)
  end

  def timed_out
    (timeout=128) + (kill=9)
  end

end

