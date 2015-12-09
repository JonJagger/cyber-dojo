
class Caches

  def initialize(dojo, path)
    @dojo = dojo
    @path = path
  end

  attr_reader :path

  def parent
    @dojo
  end

  private

  include ExternalParentChainer
  include ExternalDir

  send :public, :write_json, :read_json

end
