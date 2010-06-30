
class Dojo

  def self.names
    Dir.entries(Root_folder).select { |name| !dotted? name }
  end

  def initialize(name)
    @name = name
  end

  def name
    @name
  end

  def kata_names
    Dir.entries(folder).select { |name| !Dojo.dotted? name }
  end

  def avatars
    alive = []
    Avatar.names.each do |avatar_name|
      alive << Avatar.new(self, avatar_name) if File.exists?(folder + '/' + avatar_name)
    end
    alive
  end

  def folder
    Root_folder + '/' + name
  end

private

  def self.dotted? name
    name == '.' or name == '..'
  end

  Root_folder = RAILS_ROOT + '/' + 'dojos'

end


