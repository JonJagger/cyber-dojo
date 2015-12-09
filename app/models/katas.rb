
class Katas
  include Enumerable

  def initialize(dojo, path)
    @dojo = dojo
    @path = path
  end

  attr_reader :path

  def parent
    @dojo
  end

  def create_kata(language, exercise, id = unique_id, now = time_now)
    # a kata's id has 10 hex chars. This gives 16^10 possibilities
    # which is 1,099,511,627,776 which is big enough to not
    # need to check that a kata with the id already exists.
    manifest = create_kata_manifest(language, exercise, id, now)
    manifest[:visible_files] = language.visible_files
    manifest[:visible_files]['output'] = ''
    text = [
      'Note: The initial code and test files form a',
      'simple example to start you off.',
      'They are *not* related to the chosen exercise,',
      'whose instructions now follow...',
      '- - - - - - - - - - - - - - - - - - - - - - -',
      ''
    ].join("\n") + exercise.instructions
    manifest[:visible_files]['instructions'] = text
    kata = Kata.new(self, id)
    disk[kata.path].make
    disk[kata.path].write_json('manifest.json', manifest)
    kata
  end

  def create_kata_manifest(language, exercise, id, now)
    {             created: now,
                       id: id,
                 language: language.name,
                 exercise: exercise.name,
      unit_test_framework: language.unit_test_framework,
                 tab_size: language.tab_size
    }
  end

  def each
    return enum_for(:each) unless block_given?
    disk[path].each_dir do |outer_dir|
      disk[path + outer_dir].each_dir do |inner_dir|
        yield self[outer_dir + inner_dir]
      end
    end
  end

  def [](id)
    kata = Kata.new(self, id)
    valid?(id) && disk[kata.path].exists? ? kata : nil
  end

  def complete(id)
    # If at least 6 characters of the id are provided attempt to complete
    # it into the full 10 character id. Doing completion with fewer characters
    # would likely result in a lot of disk activity and no unique outcome.
    if !id.nil? && id.length >= 6
      outer_dir = disk[path + outer(id)]
      if outer_dir.exists?
        dirs = outer_dir.each_dir.select { |inner_dir| inner_dir.start_with?(inner(id)) }
        id = outer(id) + dirs[0] if dirs.length == 1
      end
    end
    id || ''
  end

  private

  include ExternalParentChainer
  include IdSplitter
  include TimeNow
  include UniqueId

  def valid?(id)
    id.class.name == 'String' &&
      id.length == 10 &&
        id.chars.all? { |char| hex?(char) }
  end

  def hex?(char)
    '0123456789ABCDEF'.include?(char)
  end

end
