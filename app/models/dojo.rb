
class Dojo

  def initialize(name)
    @name = name
  end

  def name
    @name
  end

  def kata(kata_name, avatar_name = "", readonly = false)
    Kata.new(self, kata_name, avatar_name, readonly)
  end

  def folder
    'dojos' + '/' + name
  end

end


