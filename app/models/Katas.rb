require 'Externals'

class Katas
  include Enumerable
  include Externals

  def initialize(dojo)
    @dojo = dojo
  end

  attr_reader :dojo

  def path
    dojo.path + 'katas/'
  end

  def each
    # dojo.katas.each
    disk[path].each do |outer_dir|
      outer_path = File.join(path, outer_dir)
      if disk.is_dir?(outer_path)
        disk[outer_path].each do |inner_dir|
          inner_path = File.join(outer_path, inner_dir)
          if disk.is_dir?(inner_path)
            yield self[outer_dir + inner_dir]
          end
        end
      end
    end
  end

  def [](id)
    # dojo.katas[id]
    Kata.new(dojo,id)
  end

end
