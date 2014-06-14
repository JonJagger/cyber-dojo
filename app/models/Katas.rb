require 'Externals'

class Katas
  include Enumerable
  include Externals

  def initialize(dojo)
    @dojo = dojo
  end

  attr_reader :dojo

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
    kata = Kata.new(dojo, id)
    kata.dir.write(kata.manifest_filename, manifest)
    kata
  end

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

private

  def make_time(now)
    [now.year, now.month, now.day, now.hour, now.min, now.sec]
  end

end
