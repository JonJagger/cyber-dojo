
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

  #def new_kata(name)
  #  Kata.new(self, name) 
  #end

  def new_kata(language_name, kata_name)
    Kata.new(self, language_name, kata_name) 
  end

  def katas
    alive = []
    Dir.entries(folder).select { |entry| !Dojo.dotted? entry }.each do |kata_name|
      kata = Kata.new(self, kata_name)
      if kata.avatars.size > 0
        alive << kata
      end
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


