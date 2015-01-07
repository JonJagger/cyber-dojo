
# See cyber-dojo-model.pdf

class Dojo

  def initialize
  end

  def languages
    @languages ||= Languages.new
  end

  def exercises
    @exercises ||= Exercises.new
  end

  def katas
    @katas ||= Katas.new(self)
  end

  def finished_katas
    @finished_katas ||= FinishedKatas.new(self)
  end

end
