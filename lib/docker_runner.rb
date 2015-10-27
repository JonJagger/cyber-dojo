
# test runner providing isolation/protection/security
# via Docker containers https://www.docker.io/
# and relying on docker volume mounts on host to
# give /katas/ state access to docker process containers.
#
# Comments at end of file

require_relative './docker_times_out_runner'
require 'tempfile'

class DockerRunner

  def self.cache_filename
    'docker_runner_cache.json'
  end

  def initialize(caches, bash = Bash.new, cid_filename = Tempfile.new('cyber-dojo').path)
    @caches = caches
    @bash = bash
    @cid_filename = cid_filename
  end

  def runnable?(language)
    image_names.include?(language.image_name)
  end

  def run(sandbox, command, max_seconds)
    read_write = 'rw'
    sandbox_volume = "#{sandbox.path}:/sandbox:#{read_write}"
    options =
        ' --net=none' +
        " -v #{quoted(sandbox_volume)}" +
        ' -w /sandbox'
    language = sandbox.avatar.kata.language
    cmd = timeout(command, max_seconds)
    times_out_run(options, language.image_name, cmd, max_seconds)
  end

  def refresh_cache
    output, _ = bash('docker images')
    lines = output.split("\n").select { |line| line.start_with?('cyberdojofoundation') }
    cache = lines.collect { |line| line.split[0] }
    caches.write_json(self.class.cache_filename, cache)
  end

  private

  include DockerTimesOutRunner

  attr_reader :caches

  def image_names
    @image_names ||= caches.read_json(self.class.cache_filename)
  end

end


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# "docker run" +
#    ' --net=none' +
#    " -v #{quoted(sandbox_volume)}" +
#    " -w /sandbox" +
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# --net=none
#
#   Turn off all networking inside the container.
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# -v #{quoted(sandbox_volume)}
#
#   Volume mount the animal's sandbox to /sandbox inside the docker
#   container as a read-write folder. This provides isolation.
#   Important to quote the volume incase any paths contain spaces
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# -w /sandbox
#
#   Working directory when the command is run is /sandbox
#   (as volume mounted in the first -v option)
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

