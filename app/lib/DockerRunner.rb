
# runner providing some isolation/protection/security
# Uses Docker containers
# https://www.docker.io/

class DockerRunner

  def runnable?(language)
    command = stderr2stdout('docker images')
    output = `#{command}`
    @installed ||= output.lines.each.collect{|line| line.split[0]}
    @installed.include?(language.image_name)
  end

  def run(paas, sandbox, command, max_seconds)
    inner_command = "timeout --signal=#{kill} #{max_seconds}s #{stderr2stdout(command)}"
    language = sandbox.avatar.kata.language
    outer_command =
      "docker run" +
        " -u root" +
        " --rm" +
        " -v #{paas.path(sandbox)}:/sandbox:#{read_write}" +
        " -v #{paas.path(language)}:#{paas.path(language)}:#{read_only}" +
        " -w /sandbox" +
        " #{language.image_name} /bin/bash -c \"#{inner_command}\""

    output = `#{outer_command}`
    $?.exitstatus != fatal_error(kill) ? output : terminated_after(max_seconds)
  end

private

  def stderr2stdout(cmd)
    cmd + ' 2>&1'
  end

  def fatal_error(signal)
    128 + signal
  end

  def kill
    9
  end

  def terminated_after(max_seconds)
    "Terminated by the cyber-dojo server after #{max_seconds} seconds."
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
#    " -v #{paas.path(sandbox)}:/sandbox:#{read_write}" +
#    " -v #{paas.path(language)}:#{paas.path(language)}:#{read_only}" +
#    " -w /sandbox" +
#    " #{language.image_name} /bin/bash -c \"#{inner_command}\""
#
# -u root
#   run as user=root
#
# --rm
#   automatically remove the container created by running inner_command
#   on the base container - we are only interested in the output produced.
#   all files are saved and gitted into the /katas folder on the main
#   server and not into the container
#
# -v #{paas.path(sandbox)}:/sandbox:#{read_write}
#   volume mount the animal's sandbox to /sandbox inside the container
#   as a read-write folder. This provides isolation.
#
# -v #{paas.path(language)}:#{paas.path(language)}:#{read_only}
#  volume mount the language's folder to the same folder path+name
#  inside the container. Intermediate folders are created as necessary
#  (like mkdir -p). This provides access to supporting files which
#  were sym-linked from the animal's sandbox when the animal started.
#  Not all languages have symlinks but it's simpler to just do it anyway.
#  Mounted as a read-only volume since these support files are shared
#  by all animals in all katas that choose that language.
#
# -w /sandbox
#  working directory when the command is run is /sandbox (as volume
#  mounted in the first -v option)
#
# #{language.image_name} /bin/bash -c \"#{inner_command}\"
#  the container to run the command inside is the one specified in
#  the language's manifest as its image_name. The command is always
#  './cyber-dojo.sh' which is run via bash.
#