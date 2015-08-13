
# test runner providing isolation/protection/security
# via Docker containers https://www.docker.io/
# and relying on git clone from git-server to give state
# access to docker process containers.

require_relative 'Runner'

class DockerGitCloneRunner

  def initialize(bash = Bash.new)
    @bash = bash
    raise RuntimeError.new("Docker not installed") if !installed?
  end

  def runnable?(language)    
    # - - - - - - - - - - - - - -
    # sym-linked support-files cannot be supported because
    # a docker swarm cannot volume mount.
    # - - - - - - - - - - - - - -
    # Approval style tests are disabled because their
    # post run .txt file processing is not trivial on
    # a docker swarm solution.
    # - - - - - - - - - - - - - - 
    language.support_filenames == [] &&
      !language.display_name.end_with?('Approval')
  end

  def git_server
    # Assumes...
    # 1. user called git on git server
    # 2. user called cyber-dojo on cyber-dojo server
    # 3. www-data can sudo -u cyber-dojo
    # 4. git-daemon running on git server to publically
    #    serve git repos with --base-path=/opt/git
    # 5. git-server has port 9418 open
    "192.168.59.103"
  end

  def opt_git_kata_path(kata)
    '/opt/git' + kata_path(kata)
  end

  def kata_path(kata)
    id = kata.id.to_s
    outer = id[0..1]
    inner = id[2..-1]
    "/#{outer}/#{inner}"
  end
  
  def started(avatar)
    kata = avatar.kata
  
    cmds = [
      "cd #{kata.path}",
      "git clone --bare #{avatar.name} #{avatar.name}.git",
      # scp -r says it makes directories as needed but it doesn't seem to
      # so I'm preceeding the scp with the mkdir -p
      "sudo -u cyber-dojo ssh git@#{git_server} 'mkdir -p #{opt_git_kata_path(kata)}'",
      "sudo -u cyber-dojo scp -r #{avatar.name}.git git@#{git_server}:#{opt_git_kata_path(kata)}",
      # allow git-daemon to server the repo
      "sudo -u cyber-dojo ssh git@#{git_server} 'touch #{opt_git_kata_path(kata)}/#{avatar.name}.git/git-daemon-export-ok'",
      "rm -rf #{avatar.name}.git",
      "cd #{avatar.path}",
      "git remote add master git@#{git_server}:#{opt_git_kata_path(kata)}/#{avatar.name}.git",
      "sudo -u cyber-dojo git push --set-upstream master master"
    ].join(';')
    o,es = bash(cmds)
    #raise cmds + "\n\n" + "output=\n" + o.to_s + "error_status=\n" + es.to_s
  end
  
  def pre_test(avatar)
    # if no visible files have changed this is a safe no-op
    cmds = [
      "cd #{avatar.path}",
      "sudo -u cyber-dojo git commit -am 'pre-test-pull' --quiet",
      "sudo -u cyber-dojo git push master"
    ].join(';')
    o,es = bash(cmds)
    #alert(cmds,o,es)
  end
  
  def post_commit_tag(avatar)
    cmds = [
      "cd #{avatar.path}",
      "sudo -u cyber-dojo git push master"
    ].join(';')
    o,es = bash(cmds)
  end

  def run(sandbox, command, max_seconds)
    avatar = sandbox.avatar
    kata = avatar.kata
    cidfile = avatar.path + 'cidfile.txt'
    language = kata.language
    
    # Assumes git-daemon on the git server
    cmds = [
      "git clone git://#{git_server}#{kata_path(kata)}/#{avatar.name}.git /tmp/#{avatar.name} 2>&1 > /dev/null",
      "cd /tmp/#{avatar.name}/sandbox && #{command}"
    ].join(';')

    # Using --net=host to get something working. This is not secure.
    # Would prefer to restrict it to just accessing the git server.
    docker_command = 
      "docker run" +
      " -u www-data" +
      " --net=host" +
      " --cidfile=#{quoted(cidfile)}" +
      " #{language.image_name}" +
      " /bin/bash -c" +
      " #{quoted(timeout(cmds,max_seconds))}"

    outer_command = timeout(docker_command,max_seconds+5)
   
    bash("rm -f #{cidfile}")
    output,exit_status = bash(outer_command)
    pid,_ = bash("cat #{cidfile}")
    bash("docker stop #{pid} ; docker rm #{pid}")

    exit_status != fatal_error(kill) ? limited(output) : didnt_complete(max_seconds)

    # Note: Should run(sandbox,...) be run(avatar,...)?  I think so.
    # Note: command being passed in allows extra testing options.
    # Note: extracting DockerRunner that just does run() into dedicated class.
  end

private
  
  include Runner  
  include Stderr2Stdout
   
  def bash(command)
    @bash.exec(command)
  end

  def installed?
    _,exit_status = bash(stderr2stdout('docker info > /dev/null'))
    exit_status === 0
  end

  def timeout(command,after)
    "timeout --signal=#{kill} #{after}s #{stderr2stdout(command)}"
  end

  def quoted(arg)
    '"' + arg + '"'
  end

  def fatal_error(signal)
    128 + signal
  end

  def kill
    9
  end

end

