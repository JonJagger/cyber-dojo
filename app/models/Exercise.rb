
class Exercise

  def initialize(path,name,disk)
    @path,@name,@disk = path,name,disk
  end

  attr_reader :name

  def new_name
    # Some exercises/ sub-folders have been renamed.
    # See app/models/Kata.rb ::exercise()
    # See app/models/Kata.rb ::original_exercise()
    renames = {
      'Yahtzee' => 'Yatzy',
      'Yahtzee_Cutdown' => 'Yatzy_Cutdown'
    }
    renames[name] || name
  end

  def exists?
    dir.exists?(instructions_filename)
  end

  def instructions
    clean(dir.read(instructions_filename))
  end

  def dir
    @disk[path]
  end

  def path
    @path + name + '/'
  end

private

  def instructions_filename
    'instructions'
  end

  include Cleaner

end
