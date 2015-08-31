# See comments at end of file

class Katas

  include ExternalParentChain
  include Enumerable
  
  def initialize(dojo,path)
    @parent,@path = dojo,path
    @path += '/' if !@path.end_with? '/'
  end

  def dojo
    @parent
  end
  
  attr_reader :path

  def create_kata(language, exercise, id = unique_id, now = time_now)
    manifest = create_kata_manifest(language, exercise, id, now)
    manifest[:visible_files] = language.visible_files
    manifest[:visible_files]['output'] = ''
    text = [
      "Note: The initial code and test files form a",
      "simple example to start you off.",
      "They are *not* related to the chosen exercise,",
      "whose instructions now follow...",
      "- - - - - - - - - - - - - - - - - - - - - - -",
      ""
    ].join("\n") + exercise.instructions
    manifest[:visible_files]['instructions'] = text
    kata = self[id]
    kata.dir.write('manifest.json', manifest)
    kata.dir.write('started_avatars.json', [])
    kata
  end

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

  def each
    return enum_for(:each) unless block_given?
    dir.each_kata_id do |id|
      yield self[id]
    end  
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

  include UniqueId
  include TimeNow

  def is_hex?(char)
    '0123456789ABCDEF'.include?(char)
  end

end


# - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# create_kata
# - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# a kata's id has 10 hex chars. This gives 16^10 possibilities
# which is 1,099,511,627,776 which is big enough to not
# need to check that a kata with the id already exists.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - -


# - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# complete
# - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# if at least 4 characters of the id are
# provided attempt to do id-completion
# Doing completion with fewer characters would likely result
# in a lot of disk activity and no unique outcome.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - -
