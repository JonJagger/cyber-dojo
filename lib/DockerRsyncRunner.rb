# test runner providing isolation/protection/security
# via Docker containers https://www.docker.io/
# and relying on rsync-daemon running the host server to
# give /katas/ state access to docker process containers.
#
# Comments at end of file

require_relative 'DockerTimesOutRunner'
require 'tempfile'
require 'resolv'

class DockerRsyncRunner

  def initialize(bash = Bash.new, cid_filename = Tempfile.new('cyber-dojo').path)
    @bash,@cid_filename = bash,cid_filename
    raise_if_docker_not_installed
    @ip_address,_ = bash("ip route show | grep docker0 | awk '{print $9}' | tr -d '\n'")
    raise_if_bad_ip_address
  end

  def run(sandbox, command, max_seconds)
    options = "-e RSYNC_PASSWORD='password'"
    avatar = sandbox.avatar
    kata = avatar.kata
    language = kata.language
    id = kata.id.to_s    
    kata_path = "#{outer(id)}/#{inner(id)}"
    cmds = [
      "rsync -rtW cyber-dojo@#{@ip_address}::katas/#{kata_path}/#{avatar.name}/sandbox /tmp",
      "cd /tmp/sandbox && #{timeout(command,max_seconds)}"
    ].join(';')

    times_out_run(options, language.image_name, cmds, max_seconds)
  end

private

  include DockerTimesOutRunner
  include IdSplitter

  def raise_if_bad_ip_address
    raise RuntimeError.new("bad ip #{@ip_address}") if (@ip_address =~ Resolv::IPv4::Regex) != 0
  end

  def sudoi(cmd)
    cmd
  end

end


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# "docker run" +
#    ' --e RSYNC_PASSWORD='password'
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# -e RSYNC_PASSWORD='password'
#
#   Set RSYNC_PASSWORD environment variable inside docker container.
#   This ensures the rsync command to download the katas/ sub-folder
#   does not ask for a password.
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

