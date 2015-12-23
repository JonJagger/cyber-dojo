
# cyber-dojo does not use a database. Instead it uses git.
# Every individual animal has its own git repo.
# Every [test] event causes a new git commit + git tag

class HostGit

  def initialize(dojo)
    @dojo = dojo
  end

  # queries

  def parent
    @dojo
  end

  def show(path, options)
    output_of(shell.cd_exec(path, "git show #{options}"))
  end

  def diff(path, n, m)
    options = [
      '--ignore-space-at-eol',
      '--find-copies-harder',
      "#{n}",
      "#{m}",
      'sandbox'
    ].join(space = ' ')
    output_of(shell.cd_exec(path, "git diff #{options}"))
  end

  # modifiers

  def setup(path, user_name, user_email)
    shell.cd_exec(path,
      'git init --quiet',
      "git config user.name #{quoted(user_name)}",
      "git config user.email #{quoted(user_email)}"
    )
  end

  def rm(path, filename)
    shell.cd_exec(path, "git rm #{quoted(filename)}")
  end

  def add(path, filename)
    shell.cd_exec(path, "git add #{quoted(filename)}")
  end

  def commit(path, tag)
    shell.cd_exec(path,
      "git commit -a -m #{tag} --quiet",
      'git gc --auto --quiet',
      "git tag -m '#{tag}' #{tag} HEAD"
    )
  end

  private

  include ExternalParentChainer

  def quoted(s)
    "'" + s + "'"
  end

  def output_of(args)
    args[0]
  end

end
