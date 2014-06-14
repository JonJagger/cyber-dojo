
# Platform As A Service

class Paas

  def initialize(disk, git, runner)
    @disk,@git,@runner,@format = disk,git,runner,'json'
    thread = Thread.current
    thread[:disk]   ||= disk
    thread[:git]    ||= git
    thread[:runner] ||= runner
  end

  def format
    @format
  end

  def format_rb
    # only required when a test wants to create a paas
    # using old-style rb manifest files which are eval'd
    @format = 'rb'
  end

  def create_dojo(root)
    Dojo.new(self, root, format)
  end

end
