
# test runner providing isolation/protection/security
# via Docker containers https://www.docker.io/ optionally
# in a docker-swarm and relying on git clone from git-server running
# git-daemon to give state access to docker process containers.
#
# Comments at end of file

require_relative 'DockerTimesOutRunner'
require 'tempfile'

class DockerGitCloneRunner # Work-in-progress

  def initialize(bash = Bash.new, cid_filename = Tempfile.new('cyber-dojo').path)
    @bash,@cid_filename = bash,cid_filename
    raise_if_docker_not_installed
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def started(avatar)
    # Setup git repo on git-server for avatar

    # TODO: Suppose there is an avatar created *before* the move to docker-swarm
    #       I want to be able to re-enter it and then continue. But I don't
    #       think that will work unless the already existing avatar's folder has
    #       the following commands run on it so it can then push to the git server.
    #
    #       One way to resolve this might be to move this inside the run() command
    #       and only run it once by detecting if the avatar's repo already has a remote.
    #       This is a nice solution in that it also removes the need for this
    #       "special" method which is a no-op in DockerVolumeMountRunner.rb
    #       This might also be a better place to do the
    #           git.config(path, 'push.default current')
    #       which is currently in Avatar.git_setup()
    #       How to tell if a remote git-server has already been setup?
    #       I guess to a 'git remote -a' and grep the output

    # I think the code below is overly complicated
    # See http://thelucid.com/2008/12/02/git-setting-up-a-remote-repository-and-doing-an-initial-push/
    # How about this...
    #
    # 1. setup git-server
    # git_server = "git@#{git_server_ip}"
    # repo_dir = "#{opt_git_kata_path(kata)/#{avatar.name}.git"
    #
    # ssh #{git_server} 'mkdir -p #{repo_dir}'
    # ssh #{git_server} 'cd #{repo_dir} && git init --bare'
    # ssh #{git_server} 'cd #{repo_dir} && touch git-daemon-export-ok'
    # (collapse these into one command)
    # cd #{avatar.path} && git remote add git-server #{git_server}:#{repo_dir}
    # cd #{avatar.path} && git push --set-upstream git-server git-server
    # (collapse these into one command)
    #
    # 2. push to git-server
    # sudo -u cyber-dojo git commit -am 'pre-test-push' --quiet",
    # sudo -u cyber-dojo git push git-server"
    #
    #
    # Also, the repeated sudo -u cyber-dojo below suggested I should create
    # a sudo_bash class which runs the command you give it as a sudo
    # That will require all command to work with 
    #    sudo -u cyber-dojo -i
    # and some of them don't yet have the -i option
    #    sudo -u cyber-dojo

    kata = avatar.kata  
    cmds = [
      # Clone the avatar's repo into a bare repo ready for the git-server
      "cd #{kata.path}",
      "git clone --bare #{avatar.name} #{avatar.name}.git",
      # Copy the bare repo to the git-server.
      # scp -r says it makes directories as needed but it doesn't seem to
      # which is why I'm preceding the scp with the mkdir -p
      "sudo -u cyber-dojo ssh git@#{git_server_ip} 'mkdir -p #{opt_git_kata_path(kata)}'",
      "sudo -u cyber-dojo scp -r #{avatar.name}.git git@#{git_server_ip}:#{opt_git_kata_path(kata)}",
      # Allow git-daemon to serve it
      "sudo -u cyber-dojo ssh git@#{git_server_ip} 'touch #{opt_git_kata_path(kata)}/#{avatar.name}.git/git-daemon-export-ok'",
      # Remove bare repo from cyber-dojo server now its on the git-server
      "rm -rf #{avatar.name}.git",
      # Prepare avatar's repo to push to git-server
      "cd #{avatar.path}",
      "git remote add master git@#{git_server_ip}:#{opt_git_kata_path(kata)}/#{avatar.name}.git",
      "sudo -u cyber-dojo git push --set-upstream master master"
    ].join(';')
    o,es = bash(cmds)
  end
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def run(sandbox, command, max_seconds)
    avatar = sandbox.avatar
    kata = avatar.kata

    # Assumes git daemon on the git server. 
    git_push(avatar)
    # Pipes all output from git clone to dev/null to stop it becoming part
    # of the output visible in the browser which could affect traffic-light colour.
    cmds = [
      "git clone git://#{git_server_ip}#{kata_path(kata)}/#{avatar.name}.git /tmp/#{avatar.name} 2>&1 > /dev/null",
      "cd /tmp/#{avatar.name}/sandbox && #{timeout(command,max_seconds)}"
    ].join(';')
    
    # Using --net=host just to get something working. This is insecure.
    # TODO: restrict it to just accessing the git server, port 9418
    times_out_run('--net=host', kata.language.image_name, cmds, max_seconds)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def git_server_ip
    # TODO: this will need to be set from external ENV[] setting
    '46.101.57.179'
  end

  include DockerTimesOutRunner
  include IdSplitter

private

  def git_push(avatar)
    # Changes from browser have already been reflected in avatar's sandbox.
    # Push them to the git-server so docker container can git clone them.
    # If no visible files have changed this will be a safe no-op
    cmds = [
      "cd #{avatar.path}",
      "sudo -u cyber-dojo git commit -am 'pre-test-push' --quiet",
      "sudo -u cyber-dojo git push master"
    ].join(';')
    o,es = bash(cmds)    
  end

  def opt_git_kata_path(kata)
    '/opt/git' + kata_path(kata)
  end
  
  def kata_path(kata)
    id = kata.id.to_s
    "/#{outer(id)}/#{inner(id)}"
  end

  def sudoi(cmd)
    # If docker-swarm is being used the cyber-dojo user is assumed
    # to have their docker-machine environment variables setup
    # See notes/scaling/setup-cyber-dojo-user.txt
    'sudo -u cyber-dojo -i' + ' ' + cmd.strip
  end

end


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# The bash commands are run as a user called cyber-dojo.
#
# Assumptions:
#
# 1. git push from cyber-dojo server to git-server
#
# o) www-data (apache user) can sudo -u cyber-dojo on the cyber-dojo server
# o) there is a user called cyber-dojo on the cyber-dojo server!
# o) there is a user called git on the git server.
# o) user cyber-dojo can ssh onto the git server as user git
# o) the git-server ssh port (22) is open (only) for cyber-dojo server
#
# 2. git-clone from git-server onto a docker-swarm-node
#
# o) git server has git-daemon running to publically serve repos with a --base-path=/opt/git
# o) on the git server git-daemons' port (9418) is open to (only) the docker swarm nodes.

