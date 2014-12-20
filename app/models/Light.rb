
# See comment at bottom of Avatar.rb

class Light

  def initialize(avatar,hash)
    @avatar,@hash = avatar,hash
  end

  attr_reader :avatar

  def colour
    # old katas used 'outcome'
    (@hash['colour'] || @hash['outcome']).to_sym
  end

  def time
    Time.mktime(*@hash['time'])
  end

  def number
    @hash['number'].to_i
  end

  def to_json
    {
      'colour' => colour,
      'time'   => time,
      'number' => number
    }
  end

  def tag
    avatar.tags[number]
  end

end
