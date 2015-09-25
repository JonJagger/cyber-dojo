
# See comment at bottom of Avatar.rb

class Tag
  include ExternalParentChain

  def initialize(avatar, hash)
    @parent = avatar
    @hash = hash
  end

  def avatar
    @parent
  end

  def visible_files
    @manifest ||= JSON.parse(git.show(path, "#{number}:manifest.json"))
  end

  def output
    # Very early dojos didn't store output in initial commit
    visible_files['output'] || ''
  end

  def time
    # todo: times ?need? to come from browser and use iso8601
    Time.mktime(*hash['time'])
  end

  def light?
    # Very early dojos used outcome
    hash.include?('colour') || hash.include?('outcome')
  end

  def colour
    # if this is called on tag that is not a light
    # it will raise a NoMethodError
    (hash['colour'] || hash['outcome']).to_sym
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
    # badly named but dojos on disk have stored
    # hash with 'number' as the key - make private?
    hash['number']
  end

  private

  attr_reader :hash
  
  def path
    @parent.path
  end
  
end

