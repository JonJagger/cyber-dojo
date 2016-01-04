
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
    manifest[:visible_files]['instructions'] = exercise.instructions
    kata = Kata.new(self, id)
    history.create_kata(kata, manifest)
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
    history.katas_each(self) do |id|
      yield Kata.new(self, id)
    end
  end

  def [](id)
    kata = Kata.new(self, id)
    valid?(id) && history.kata_exists?(kata) ? kata : nil
  end

  def complete(id)
    history.katas_complete_id(self, id)
  end

  private

  include ExternalParentChainer
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
