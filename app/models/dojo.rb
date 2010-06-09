
class Dojo

  def self.names
    Dir.entries(Root_folder).select { |name| !dot? name }
  end

  def initialize(name)
    @name = name
  end

  def name
    @name
  end

  def kata_names
    Dir.entries(folder).select { |name| !dot? name }
  end

  def new_kata(name)
    Kata.new(self, name) 
  end

  def katas
    alive = []
    Dir.entries(folder).select { |entry| !dot? entry }.each do |kata_name|
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

  Root_folder = 'dojos'

end


