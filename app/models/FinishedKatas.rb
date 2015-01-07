
class FinishedKatas

  def initialize(dojo)
    @dojo = dojo
    @finished_path = finished_path
    @finished_path += '/' if !finished_path.end_with?('/')
  end

  attr_reader :dojo

  def path
    @finished_path
  end

  def each
    return enum_for(:each) unless block_given?
    disk[path].each_dir do |outer_dir|
      disk[path + outer_dir].each_dir do |inner_dir|
        yield self[outer_dir + inner_dir]
      end
    end
  end

  def complete(id)
    # if at least 4 characters of the id are
    # provided attempt to do id-completion
    # Doing completion with fewer characters would likely result
    # in a lot of disk activity and no unique outcome
    if !id.nil? && id.length >= 4 && id.length < 10
      id.upcase!
      inner_dir = disk[path + id[0..1]]
      if inner_dir.exists?
        dirs = inner_dir.each_dir.select { |outer_dir|
          outer_dir.start_with?(id[2..-1])
        }
        id = id[0..1] + dirs[0] if dirs.length === 1
      end
    end
    id || ''
  end

  def [](id)
    Kata.new(self,id)
  end

  def valid?(id)
    id.class.name === 'String' &&
    id.length === 10 &&
    id.chars.all?{ |char| is_hex?(char) }
  end

  def exists?(id)
    valid?(id) && self[id].exists?
  end

private

  include Externals
  include UniqueId
  include TimeNow

  def is_hex?(char)
    '0123456789ABCDEF'.include?(char)
  end

end
