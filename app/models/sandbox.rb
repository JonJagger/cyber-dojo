
class Sandbox

  def initialize(avatar)
    @avatar = avatar
  end

  # queries

  attr_reader :avatar

  def parent
    avatar
  end

  def path
    avatar.path + 'sandbox/'
  end

  # modifiers

  def start
    dir.make
    avatar.visible_files.each { |filename, content| git_add(filename, content) }
  end

  def save_files(delta, files)
    delta[:deleted].each { |filename| git.rm(path, filename) }
    delta[:new    ].each { |filename| git_add(filename, files[filename]) }
    delta[:changed].each { |filename|   write(filename, files[filename]) }
  end

  def run_tests(max_seconds)
    clean(runner.run(self, max_seconds))
  end

  private

  include ExternalParentChainer
  include ExternalDir
  include OutputCleaner

  def git_add(filename, content)
    write(filename, content)
    git.add(path, filename)
  end

end
