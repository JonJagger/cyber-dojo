root = '../..'
require_relative root + '/lib/UniqueId'
require_relative root + '/lib/TimeNow'

class Katas

  include Enumerable

  def initialize(dojo,path,externals)
    @dojo,@path,@externals = dojo,path,externals
  end

  attr_reader :dojo, :path

  def create_kata_manifest(language, exercise, id, now)
    {
      :created => now,
      :id => id,
      :language => language.name,
      :exercise => exercise.name,
      :unit_test_framework => language.unit_test_framework,
      :tab_size => language.tab_size
    }
  end

  def create_kata(language, exercise, id = unique_id, now = time_now)
    # a kata's id has 10 hex chars. This gives 16^10 possibilities
    # which is 1,099,511,627,776 which is big enough to not
    # need to check that a kata with the id already exists.
    manifest = create_kata_manifest(language, exercise, id, now)
    manifest[:visible_files] = language.visible_files
    manifest[:visible_files]['output'] = ''
    manifest[:visible_files]['instructions'] = exercise.instructions
    kata = self[id]
    kata.dir.write('manifest.json', manifest)
    kata
  end

  def each
    # dojo.katas.each {|kata| ...}
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
    Kata.new(self,id,@externals)
  end

  def valid?(id)
    id.class.name === 'String' &&
    id.length === 10 &&
    id.chars.all?{|char| is_hex?(char)}
  end

  def exists?(id)
    valid?(id) && self[id].exists?
  end

private

  include UniqueId
  include TimeNow

  def disk
    @externals[:disk]
  end

  def is_hex?(char)
    '0123456789ABCDEF'.include?(char)
  end

end
