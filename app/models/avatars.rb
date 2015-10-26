
class Avatars

  def self.names
    %w(alligator buffalo cheetah deer  elephant frog  gorilla hippo
       koala     lion    moose   panda raccoon  snake wolf    zebra
    )
  end

  def initialize(kata)
    @parent = kata
  end

  def each(&block)
    started_avatars.values.each(&block)
  end

  def [](name)
    started_avatars[name]
  end

  def active
    select(&:active?)
  end

  def names
    collect(&:name)
  end

  private

  include Enumerable
  include ExternalParentChain

  def path
    @parent.path
  end

  def started_avatars
    # Old dojos didn't use a 'started_avatars.json' file.
    # Retro-fit them so they do. Important for a dojo with
    # a lot of avatars.
    names = []
    dir.lock do
      filename = 'started_avatars.json'
      if exists?(filename)
        names = read_json(filename)
      else
        write_json(filename, names = avatars_names)
      end
    end
    Hash[names.map{ |name| [name,Avatar.new(@parent, name)]}]
  end

  def avatars_names
    names = []
    Avatars.names.each do |name|
      avatar = Avatar.new(@parent, name)
      names << name if disk[avatar.path].exists?
    end
    names
  end

end
