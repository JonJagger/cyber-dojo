
# runner that provides some isolation, some protection, some security.

class DockerRunner

  def run(paas, sandbox, command, max_seconds)
    kill = 9
    timed_out = 124
    #cid_filename = ...
    `rm #{cid_filename}`
    language = sandbox.avatar.kata.language
    cmd = "docker run -t -i --rm" +
          " -v #{paas.path(sandbox)}:/sandbox:rw" +
          " -v #{paas.path(language)}:#{path(language)}:ro"
          " -w /sandbox" +
          " --cidfile=\"#{cid_filename}\"" +
          " #{language.image_name} /bin/bash -c \"timeout --signal=#{kill} #{max_duration}s #{command}\""
    `#{cmd}`
    exitstatus = $?.exitstatus
    cid = `cat #{cid_filename}`
    (exitstatus != timed_out) ? `docker logs #{cid}` :
       "Terminated by the cyber-dojo server after #{max_duration} seconds."
  end

private

end