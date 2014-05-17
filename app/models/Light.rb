
class Light

  def initialize(avatar,hash)
    @avatar,@hash = avatar,hash
  end

  attr_reader :avatar

  def colour
    # old katas used 'outcome'
    @hash['colour'] || @hash['outcome']
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

  #def tag_number
  #end

end
