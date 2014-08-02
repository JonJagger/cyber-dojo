
# What is the difference between a Tag and a Light?
# A Tag is an entry in increments.json which indicates
# a single git commit+tag.
# A Light corresponds to a [test] event which moves
# from one tag to another tag, creating a red/amber/green
# traffic-light as it does so.
# So tag0 does not have a traffic-light (it is white)
# and (tagN -> tagN+1) has a red/amber/green traffic-light.
# I plan to create finer grained tags than just [test] events
# for example, renaming a file. If this happens the
# difference between a Tag and a Light will be much more
# pronounced.

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
