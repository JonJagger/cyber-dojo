
# runner that provides some isolation/protection/security.

class DockerRunner

  def run(paas, sandbox, command, max_seconds)
    max_seconds = 30
    Rails.logger.warn("DockerRunner")
    # TODO: move this out of katas/ subfolder
    cid_filename = paas.path(sandbox) + 'store.cid'

    `rm -f #{cid_filename}`
    language = sandbox.avatar.kata.language
    cmd = "docker run -t -i --rm" +
          " -v #{paas.path(sandbox)}:/sandbox:rw" +
          " -v #{paas.path(language)}:#{paas.path(language)}:ro" +
          " -w /sandbox" +
          " --cidfile=\"#{cid_filename}\"" +
          " #{language.image_name} /bin/bash -c \"#{command}\""

    # timeout must go on 'docker run' command and not on
    # the command passed to docker run. This is to ensure
    # the docker run command does not start doing a docker pull
    # from the docker index which could easily take considerably
    # longer than the max_seconds limit.

    Rails.logger.warn("DockerRunner.run " + cmd)

    kill = 9
    `timeout --signal=#{kill} #{max_seconds}s #{cmd}`

    exitstatus = $?.exitstatus
    killed_by_timeout = 128+kill
    cid = `cat #{cid_filename}`

    output = (exitstatus != killed_by_timeout) ? `docker logs #{cid}` :
       "Terminated by the cyber-dojo server after #{max_seconds} seconds."
  end

end
