
# See comment at bottom of avatar.rb

class Tag

  def initialize(avatar, hash)
    @avatar = avatar
    @hash = hash
  end

  # queries

  attr_reader :avatar

  def parent
    avatar
  end

  def path
    avatar.path
  end

  def visible_files
    @manifest ||= JSON.parse(git.show(path, "#{number}:manifest.json"))
  end

  def output
    # Very early dojos didn't store output in initial commit
    visible_files['output'] || ''
  end

  def time
    Time.mktime(*hash['time'])
  end

  def light?
    colour.to_s != ''
  end

  def colour
    # Very early dojos used outcome
    (hash['colour'] || hash['outcome'] || '').to_sym
  end

  def to_json
    # Used only in differ_controller.rb
    {
      'colour' => colour,
      'time'   => time,
      'number' => number
    }
  end

  def number
    hash['number']
  end

  private

  include ExternalParentChainer

  attr_reader :hash

end
