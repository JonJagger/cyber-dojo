
# test runner providing isolation/protection/security
# via Docker containers https://www.docker.io/
# and relying on git clone from git-server running
# git-daemon to give state access to docker process containers.

require_relative 'DockerRunner'

class DockerGitCloneRunner < DockerRunner

  def initialize(bash = Bash.new)
    super(bash)
  end

  def runnable?(language)    
    # Sym-linked support-files cannot be supported because
    # a docker swarm solution cannot volume mount.
    # Approval style tests are disabled because their
    # post-run .txt file retrieval is not trivial on
    # docker swarm solution.
    image_pulled?(language) &&
      !sym_linked?(language) &&
        !approval_test?(language)
  end

  def started(avatar)
    # Setup git repo on git-server for avatar
    kata = avatar.kata  
    cmds = [
      # Clone the avatar's repo into a bare repo ready for the git-server
      "cd #{kata.path}",
      "git clone --bare #{avatar.name} #{avatar.name}.git",
      # Copy the bare repo to the git-server.
      # scp -r says it makes directories as needed but it doesn't seem to
      # which is why I'm preceding the scp with the mkdir -p
      "sudo -u cyber-dojo ssh git@#{git_server} 'mkdir -p #{opt_git_kata_path(kata)}'",
      "sudo -u cyber-dojo scp -r #{avatar.name}.git git@#{git_server}:#{opt_git_kata_path(kata)}",
      # Allow git-daemon to serve it
      "sudo -u cyber-dojo ssh git@#{git_server} 'touch #{opt_git_kata_path(kata)}/#{avatar.name}.git/git-daemon-export-ok'",
      # Remove bare repo from cyber-dojo server now its on the git-server
      "rm -rf #{avatar.name}.git",
      # Prepare avatar's repo to push to git-server
      "cd #{avatar.path}",
      "git remote add master git@#{git_server}:#{opt_git_kata_path(kata)}/#{avatar.name}.git",
      "sudo -u cyber-dojo git push --set-upstream master master"
    ].join(';')
    o,es = bash(cmds)
  end
  
  def pre_test(avatar)
    # Changes from browser have been reflected in avatar's sandbox.
    # Push them to the git-server so docker container can git clone them.
    # If no visible files have changed this will be a safe no-op
    cmds = [
      "cd #{avatar.path}",
      "sudo -u cyber-dojo git commit -am 'pre-test-push' --quiet",
      "sudo -u cyber-dojo git push master"
    ].join(';')
    o,es = bash(cmds)
  end
  
  def run(sandbox, command, max_seconds)
    avatar = sandbox.avatar
    kata = avatar.kata
    language = kata.language
    # Assumes git daemon on the git server.
    # Pipes all output from git clone to dev/null to stop
    # the output of git clone becoming part of the output visible
    # in the browser and affecting the traffic-light colouring.
    cmds = [
      "git clone git://#{git_server}#{kata_path(kata)}/#{avatar.name}.git /tmp/#{avatar.name} 2>&1 > /dev/null",
      "cd /tmp/#{avatar.name}/sandbox && #{command}"
    ].join(';')
    
    # Using --net=host just to get something working. This is insecure.
    # TODO: restrict it to just accessing the git server.
    docker_run('--net=host', language.image_name, cmds, max_seconds)
  end

private
  
  include IdSplitter

  def git_server
    # Assumes:
    # 0. there is a user called cyber-dojo on the cyber-dojo server.
    # 1. www-data can sudo -u cyber-dojo on the cyber-dojo server
    # 2. there is a user called git on the git server.
    # 3. cyber-dojo can ssh into the git server as user git
    # 4. git server has git-daemon running to publically serve repos
    #    with a --base-path=/opt/git
    # 5. port 9418 is open on the git server
    # TODO: this will need to be set from external ENV[] setting
    '192.168.59.103'
  end

  def opt_git_kata_path(kata)
    '/opt/git' + kata_path(kata)
  end
  
  def kata_path(kata)
    id = kata.id.to_s
    "/#{outer(id)}/#{inner(id)}"
  end

end
