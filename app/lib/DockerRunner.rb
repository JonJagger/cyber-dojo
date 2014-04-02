
# runner that provides some isolation/protection/security.

class DockerRunner

  def run(paas, sandbox, command, max_seconds)

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

    kill = 9
    # timeout not available on OSX ...
    `timeout --signal=#{kill} #{max_seconds}s #{cmd}`

    exitstatus = $?.exitstatus
    timed_out = 124
    cid = `cat #{cid_filename}`

    output = (exitstatus != timed_out) ? `docker logs #{cid}` :
       "Terminated by the cyber-dojo Docker server after #{max_seconds} seconds."

    output += "\n"
    output += exitstatus.to_s
    output
  end

private

end

# To run docker on OSX
# http://zaiste.net/2014/02/lightweight_docker_experience_on_osx/
#
# $curl -o docker http://get.docker.io/builds/Darwin/x86_64/docker-latest
# $chmod +x ./docker
# $mv docker ~/bin
#
# $curl https://raw.github.com/steeve/boot2docker/master/boot2docker > boot2docker
# $chmod a+x boot2docker
# $mv boot2docker ~/bin/boot2docker
#
# $~/bin/boot2docker init
# $~/bin/boot2docker up
# $export DOCKER_HOST=tcp://localhost:4243
#
# $~/bin/docker version
#
# and I do not get a
# dial unix /var/run/docker.sock: no such file or directory
# error message
