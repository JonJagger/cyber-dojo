
class Dojo

  def initialize(id)
    @id = id
  end

  def id
    @id.to_s
  end

  def kata(id, name = "", readonly = false)
    Kata.new(self, id, name, readonly)
  end

  def folder
    'dojos' + '/' + id
  end

end


