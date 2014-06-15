require 'Externals'

# dojo.katas[id]
# dojo.katas.each {|kata| ...}

class Katas
  include Enumerable
  include Externals

  def initialize(dojo,path)
    @dojo,@path = dojo,path
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

  def create_kata(language, exercise, id = Id.new.to_s, now = make_time(Time.now))
    manifest = create_kata_manifest(language, exercise, id, now)
    manifest[:visible_files] = language.visible_files
    manifest[:visible_files]['output'] = ''
    manifest[:visible_files]['instructions'] = exercise.instructions
    kata = self[id]
    kata.dir.write(kata.manifest_filename, manifest)
    kata
  end

  def each
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
    Kata.new(self,id)
  end

private

  def make_time(now)
    [now.year, now.month, now.day, now.hour, now.min, now.sec]
  end

end
