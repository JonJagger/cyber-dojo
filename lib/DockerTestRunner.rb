
# test runner providing some isolation/protection/security
# via Docker containers https://www.docker.io/

require_relative 'TestRunner'

class DockerTestRunner

  include TestRunner

  def initialize
    command = stderr2stdout('docker images')
    @image_names = image_names(`#{command}`)
  end

  def runnable?(language)
    @image_names.include?(language.image_name)
  end

  def run(sandbox, command, max_seconds)
    inner_command = "timeout --signal=#{kill} #{max_seconds}s #{stderr2stdout(command)}"
    language = sandbox.avatar.kata.language
    outer_command =
      "docker run" +
        " -u root" +
        " --rm" +
        " -v #{sandbox.path}:/sandbox:#{read_write}" +
        " -v #{language.path}:#{language.path}:#{read_only}" +
        " -w /sandbox" +
        " #{language.image_name} /bin/bash -c \"#{inner_command}\""

    output = `#{outer_command}`
    $?.exitstatus != fatal_error(kill) ? output : didnt_complete(max_seconds)
  end

  def image_names(output)
    output.split("\n")[1..-1].collect{|line| line.split[0]}.sort.uniq
  end

private

  def fatal_error(signal)
    128 + signal
  end

  def kill
    9
  end

  def read_write
    'rw'
  end

  def read_only
    'ro'
  end

end

# docker run
#    " -u root" +
#    " --rm" +
#    " -v #{sandbox.path}:/sandbox:#{read_write}" +
#    " -v #{language.path}:#{language.path}:#{read_only}" +
#    " -w /sandbox" +
#    " #{language.image_name} /bin/bash -c \"#{inner_command}\""
#
# -u root
#   run as user=root
#
# --rm
#   automatically remove the container created by running inner_command
#   on the base container (language.image_name). We are only interested
#   in the output produced. All files are saved and gitted off the
#   /katas sub-folder on the main server and not into the container.
#
# -v #{sandbox.path}:/sandbox:#{read_write}
#   volume mount the animal's sandbox to /sandbox inside the container
#   as a read-write folder. This provides isolation.
#
# -v #{language.path}:#{language.path}:#{read_only}
#   volume mount the language's folder to the same folder path+name
#   inside the container. Intermediate folders are created as necessary
#   (like mkdir -p). This provides access to supporting files which
#   were sym-linked from the animal's sandbox when the animal started.
#   Not all languages have symlinks but it's simpler to just do it anyway.
#   Mounted as a read-only volume since these support files are shared
#   by all animals in all katas that choose that language.
#
# -w /sandbox
#   working directory when the command is run is /sandbox
#   (as volume mounted in the first -v option)
#
# #{language.image_name} /bin/bash -c \"#{inner_command}\"
#   the container to run the command inside is the one specified in
#   the language's manifest as its image_name. The command is always
#   './cyber-dojo.sh' which is run via bash inside a timeout.
#
