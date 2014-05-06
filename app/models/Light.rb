
class Light

  def initialize(avatar,hash)
    @avatar,@hash = avatar,hash
  end

  attr_reader :avatar

  def colour
    @hash['colour']
  end

  def time_stamp
    @hash['time']
  end

  def number
    @hash['number']
  end

  #- - - - - - - - - - - - - - - -

  #def visible_files
  #end

  #def output
  #end

  #def diff(n)
  #end

end
