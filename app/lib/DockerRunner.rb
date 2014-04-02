
# runner that provides some isolation/protection/security.

class DockerRunner

  def run(paas, sandbox, command, max_seconds)
    Rails.logger.warn("DockerRunner")
    # TODO: move this out of katas/ subfolder
    cid_filename = paas.path(sandbox) + 'store.cid'

    `rm -f #{cid_filename}`
    language = sandbox.avatar.kata.language
    cmd = "docker run -u www-data -t" +
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
    raw = `timeout --signal=#{kill} #{max_seconds}s #{cmd}`
    exitstatus = $?.exitstatus
    killed_by_timeout = 128+kill

    Rails.logger.warn("raw = #{raw}")
    cid = `cat #{cid_filename}`
    Rails.logger.warn("cid = #{cid}")
    log = `docker logs #{cid}`
    Rails.logger.warn("log = #{log}")
    `docker rm #{cid}`

    timed_out_message = "Terminated by the cyber-dojo server after #{max_seconds} seconds."
    output = (exitstatus != killed_by_timeout) ? log : timed_out_message
    Rails.logger.warn("output = #{output}")
    output
  end

end
